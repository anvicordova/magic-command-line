require_relative 'record'

class Card < Record
  has_and_belongs_to_many :colors
end