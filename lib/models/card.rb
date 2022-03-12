# frozen_string_literal: true

require_relative 'record'

class Card < Record
  paginates_per 10
  has_many :cards_colors, dependent: :destroy
  has_many :colors, through: :cards_colors

  accepts_nested_attributes_for :cards_colors, reject_if: proc { |a|
                                                            a['color_id'].blank?
                                                          }
end
