# frozen_string_literal: true

require_relative 'record'

class Card < Record
  paginates_per 10
  has_and_belongs_to_many :colors
end
