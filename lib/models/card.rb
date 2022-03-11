# frozen_string_literal: true

require_relative 'record'

class Card < Record
  paginates_per 10
  has_many :cards_colors, dependent: :destroy
  has_many :colors, through: :cards_colors
end
