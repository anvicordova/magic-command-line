# frozen_string_literal: true

require 'faraday'
require 'pry'
require 'logger'

class HttpClient
  DEFAULT_TIMEOUT = 3 # seconds

  def initialize(url:, params: {}, headers: {})
    @logger = Logger.new($stdout)
    @connection = Faraday.new(
      url:,
      params:,
      headers:,
      request: { timeout: DEFAULT_TIMEOUT }
    ) do |c|
      c.use Faraday::Response::RaiseError
    end
  end

  def fetch(endpoint:, params: {})
    begin
      response = @connection.get(endpoint, params)
    rescue Faraday::TimeoutError => e
      @logger.fatal "Request Timeout: #{e}"
    rescue Faraday::ConnectionFailed => e
      @logger.fatal "Connection failed: #{e}"
    rescue Faraday::ServerError => e
      @logger.fatal "Error while fetching endpoint: #{e}"
    end
    response
  end
end
