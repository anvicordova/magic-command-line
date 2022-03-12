# frozen_string_literal: true

class SearchResult
  attr_reader :data, :total_pages

  def initialize(data:, total_pages:)
    @data = data
    @total_pages = total_pages
  end
end
