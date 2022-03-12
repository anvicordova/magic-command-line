# frozen_string_literal: true

require 'pry'
require_relative 'cards_fetcher'
require_relative 'cards_importer'

class CardsDownloader
  attr_reader :thread_pool, :card_client, :deck

  def initialize(pool_size: 20)
    @card_client = CardsFetcher.new
    @thread_pool = pool_size
    @deck = []
  end

  def download!
    fetch_all_cards
    @deck = @deck.flatten.compact
    CardsImporter.new(json_deck: @deck).import!
  end

  def fetch_all_cards
    thread_executor.times do |i|
      thread_pool.times.map do |page|
        page_number = (thread_pool * i) + (page + 1)
        fetch_page(page_number)
      end.each(&:join)
    end
  end

  def fetch_page(page_number)
    Thread.new(deck, page_number) do
      Mutex.new.synchronize do
        deck << card_client.fetch(page: page_number)
      end
    end
  end

  def thread_executor
    page_metadata = card_client.page_metadata

    total_pages = page_metadata[:total_pages]
    cards_per_page = page_metadata[:cards_per_page]

    (total_pages / (thread_pool * cards_per_page).to_f).ceil
  end
end
