# frozen_string_literal: true

require 'pry'
require 'kaminari'
require_relative '../models/card'
require_relative '../models/color'
require_relative '../models/search_result'

class SearchCards
  attr_accessor :groups, :filter_set, :filter_colors, :scope

  def initialize(options)
    @groups = options[:groups]
    @filter_set = options[:filter_set]
    @filter_colors = options[:filter_colors]
    @page = options[:page]
    @scope = Card.all
  end

  def call
    @scope = @scope.where(set: filter_set) if filter_set

    @scope = filter_by_color if filter_colors

    return grouped_cards if groups

    result = @scope.page(@page)
    SearchResult.new(data: result , total_pages: result.total_pages)
  end

  private

  def grouped_cards
    sorted_data = @scope
      .order(groups)
      .page(@page)

    SearchResult.new(
      data: sorted_data.group_by { |card| groups.map { |g| card.send(g) } },
      total_pages: sorted_data.total_pages
    )
  end

  def filter_by_color
    @scope
      .joins(:colors)
      .where(colors: { name: filter_colors })
      .where(cards: { colors_count: filter_colors.length })
      .group('cards.id')
      .having('COUNT(cards.id) = ?', filter_colors.length)
  end
end
