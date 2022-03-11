# frozen_string_literal: true

require 'pry'
require_relative '../models/card'
require_relative '../models/color'

class SearchCards
  attr_accessor :groups, :filter_set, :filter_colors, :scope

  def initialize(options)
    @groups = options[:groups]
    @filter_set = options[:filter_set]
    @filter_colors = options[:filter_colors]
    @scope = Card
  end

  def call
    @scope = @scope.where(set: filter_set) if filter_set

    if filter_colors
      @scope = @scope
               .joins(:colors)
               .where(colors: { name: filter_colors })
               .group('cards.id')
               .having('COUNT(cards.id) = ?', filter_colors.length)
    end

    if groups
      grouped_cards.each do |k, v|
        puts "GROUP: #{k.join(' - ')}"
        puts 'CARDS'
        puts v.pluck(:name).join("\n").to_s
        puts '-------------------'
      end

      return
    end

    puts @scope.to_sql
    puts @scope.pluck(:name)
    @scope
  end

  private

  def grouped_cards
    @scope.order(groups).group_by { |card| groups.map { |g| card.send(g) } }
  end
end
