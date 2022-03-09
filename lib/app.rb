require 'json'
require_relative 'http_client'
require_relative 'models/card'

def cards  
  deck = []
  mutex = Mutex.new

  thread_pool = 20

  33.times do |i|
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
            Card.create(name: card[:name])
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

