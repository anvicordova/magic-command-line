# frozen_string_literal: true

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
        table.integer :colors_count
        table.timestamps
      end
    end
  end

  def down
    drop_table :cards if ActiveRecord::Base.connection.table_exists?(:cards)
  end
end
