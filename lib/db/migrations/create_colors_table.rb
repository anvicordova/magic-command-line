# frozen_string_literal: true

class CreateColorsTable < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:colors) # rubocop:disable Style/GuardClause
      create_table :colors do |table|
        table.string :name
        table.timestamps
      end
    end
  end

  def down
    drop_table :colors if ActiveRecord::Base.connection.table_exists?(:colors)
  end
end
