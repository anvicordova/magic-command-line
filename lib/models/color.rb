# frozen_string_literal: true

require_relative 'record'

class Color < Record
  has_many :cards_colors, dependent: :destroy
  has_many :cards, through: :cards_colors
end
