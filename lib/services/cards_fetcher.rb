# frozen_string_literal: true

require 'pry'
require 'json'
require_relative 'http_client'

class CardsFetcher
  attr_reader :client

  def initialize
    @client = HttpClient.new(url: 'https://api.magicthegathering.io')
  end

  def fetch(page:)
    response = fetch_cards_for(page:)

    if response.success? # rubocop:disable Style/GuardClause
      body = JSON.parse(response.body, symbolize_names: true)
      body[:cards]
    end
  end

  def page_metadata
    response = fetch_cards_for(page: 1)

    {
      total_pages: response.headers['total-count']&.to_i,
      cards_per_page: response.headers['page-size']&.to_i
    }
  end

  private

  def fetch_cards_for(page:)
    client.fetch(endpoint: '/v1/cards', params: { page: })
  end
end
