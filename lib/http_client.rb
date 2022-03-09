# frozen_string_literal: true

require 'faraday'
require 'pry'

class HttpClient
  DEFAULT_TIMEOUT = 3 # seconds

  def initialize(url:, params: {}, headers: {})
    @connection = Faraday.new(
      url:,
      params:,
      headers:,
      request: { timeout: DEFAULT_TIMEOUT }
    )
  end

  def fetch(endpoint:, params: {})
    begin
      response = @connection.get(endpoint, params)
    rescue Faraday::TimeoutError => e
      Rails.logger.error "Request Timeout: #{e}"
    end
    response
  end
end