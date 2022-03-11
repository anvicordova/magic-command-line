# frozen_string_literal: true

require 'json'
require 'pry'
require_relative 'http_client'
require_relative '../models/card'
require_relative '../models/color'

class DownloadCardsService
  attr_reader :client, :thread_pool

  def initialize
    @client = HttpClient.new(url: 'https://api.magicthegathering.io')
    @thread_pool = 20
  end

  def fetch_and_save_cards
    mutex = Mutex.new

    33.times do |i|
      thread_pool.times.map do |page|
        Thread.new(i, page, thread_pool) do
          mutex.synchronize do
            current_page = thread_pool * i + (page + 1)
            cards = fetch_cards_for(page: current_page)

            save_cards(cards)
          end
        end
      end.each(&:join)
    end
  end

  private

  def fetch_cards_for(page:)
    response = client.fetch(endpoint: '/v1/cards', params: { page: })

    body = JSON.parse(response.body, symbolize_names: true)
    body[:cards]
  end

  def save_cards(cards)
    cards.each do |card|
      new_card = Card.create(name: card[:name], set: card[:set], rarity: card[:rarity])

      next unless card[:colors]

      card[:colors].each do |c|
        new_card.colors << Color.find_or_create_by(name: c)
      end
    end
  end
end
