require_relative 'record'

class Color < Record
  has_and_belongs_to_many :cards
end