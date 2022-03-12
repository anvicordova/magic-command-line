# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'faraday/net_http'
require 'pry'
require 'logger'
require 'ostruct'

class HttpClient
  DEFAULT_TIMEOUT = 3 # seconds

  def initialize(url:, params: {}, headers: {}) # rubocop:disable Metrics/MethodLength
    @logger = Logger.new($stdout)
    @connection = Faraday.new(
      url:,
      params:,
      headers:,
      request: { timeout: DEFAULT_TIMEOUT }
    ) do |c|
      c.use Faraday::Response::RaiseError
      c.request(
        :retry,
        max: 3,
        interval: 0.05,
        interval_randomness: 0.5,
        backoff_factor: 2,
        exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::ServerError]
      )
      c.adapter(:net_http)
    end
  end

  def fetch(endpoint:, params: {})
    @connection.get(endpoint, params)
  rescue Faraday::TimeoutError => e
    @logger.fatal "Request Timeout: #{e}"
    OpenStruct.new(success: false)
  rescue Faraday::ConnectionFailed => e
    @logger.fatal "Connection failed: #{e}"
    OpenStruct.new(success: false)
  rescue Faraday::ServerError => e
    @logger.fatal "Error while fetching endpoint: #{e}"
    OpenStruct.new(success: false)
  end
end
