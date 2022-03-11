# frozen_string_literal: true

require 'pry'
require 'kaminari'
require_relative '../models/card'
require_relative '../models/color'

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

    return group_cards if groups

    @scope.page(@page)
  end

  private

  def group_cards
    @scope
      .order(groups)
      .page(@page)
      .group_by { |card| groups.map { |g| card.send(g) } }
  end

  def filter_by_color
    @scope
      .joins(:colors)
      .where(colors: { name: filter_colors })
      .group('cards.id')
      .having('COUNT(cards.id) = ?', filter_colors.length)
  end
end
