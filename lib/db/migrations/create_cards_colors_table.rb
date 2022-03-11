# frozen_string_literal: true

class CreateCardsColorsTable < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:cards_colors) # rubocop:disable Style/GuardClause
      create_table :cards_colors, id: false do |table|
        table.belongs_to :card
        table.belongs_to :color
      end
    end
  end

  def down
    drop_table :cards_colors if ActiveRecord::Base.connection.table_exists?(:cards_colors)
  end
end
