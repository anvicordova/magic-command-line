require 'net/http'
require 'json'
require 'pry'

def cards  
  deck = []
  mutex = Mutex.new

  thread_pool = 20

  33.times do |i|
    thread_pool.times.map do |page|
      Thread.new(deck, i, page, thread_pool) do |deck|
        mutex.synchronize do
          uri = URI('https://api.magicthegathering.io/v1/cards')
          params = { page: thread_pool * i + (page + 1) }
          uri.query = URI.encode_www_form(params)
          res = Net::HTTP.get_response(uri)
        
          card = JSON.parse(res.body)["cards"]
          if card.nil? || card.empty?
            puts "empty on page #{thread_pool * i + (page + 1)}" 
            puts "Response Body: #{res.body}"
            puts "Response RateLimit: #{res["ratelimit-remaining"]}"
            puts "Uri: #{uri}"
          end
          deck << card
        end # 100
      end
    end.each(&:join)
  end
  deck.flatten.compact
end

mtg_cards = cards

count =  mtg_cards.count
puts count

if count == 66000
  mtg_cards.last
end

