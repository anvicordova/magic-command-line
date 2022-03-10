require 'active_record'
require_relative '../connection'

Connection.new.connect

class CreateCardsTable < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:cards)
      create_table :cards do |table|
        table.string :name
        table.string :set
        table.string :rarity
        table.timestamps
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:cards)
      drop_table :cards
    end
  end
end
