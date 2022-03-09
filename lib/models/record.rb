require_relative '../db/connection'

Connection.new.connect

class Record < ActiveRecord::Base
  self.abstract_class = true
end