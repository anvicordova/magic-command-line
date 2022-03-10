require 'json'
require 'pry'
require_relative 'http_client'
require_relative 'models/card'
require_relative 'models/color'

def cards  
  deck = []
  mutex = Mutex.new

  thread_pool = 20

  1.times do |i|
    thread_pool.times.map do |page|
      Thread.new(deck, i, page, thread_pool) do |deck|
        mutex.synchronize do
          client = HttpClient.new(url: 'https://api.magicthegathering.io')
          
          response = client.fetch(
            endpoint: '/v1/cards',
            params: { page: thread_pool * i + (page + 1) }
          )

          body = JSON.parse(response.body, symbolize_names: true)
          cards = body[:cards]

          cards.each do |card|
            new_card = Card.create(
              name: card[:name],
              set: card[:set],
              rarity: card[:rarity]
            )
            
            if card[:colors]
              card[:colors].each do |c|
                new_card.colors << Color.find_or_create_by(name: c)
              end
            end
          end

          if cards.nil? || cards.empty?
            puts "empty on page #{thread_pool * i + (page + 1)}" 
            puts "Response Body: #{body}"
            puts "Response RateLimit: #{response["ratelimit-remaining"]}"
          end
        end
      end
    end.each(&:join)
  end
end

cards

count =  Card.all.count
puts count

