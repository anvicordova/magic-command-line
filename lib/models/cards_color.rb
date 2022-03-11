# frozen_string_literal: true

require_relative 'record'

class CardsColor < Record
  belongs_to :card, counter_cache: :colors_count
  belongs_to :color
end
