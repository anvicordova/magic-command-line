class CreateColorsTable < ActiveRecord::Migration[5.2]
    def up
      unless ActiveRecord::Base.connection.table_exists?(:colors)
        create_table :colors do |table|
          table.string :name
          table.timestamps
        end
      end
    end
  
    def down
      if ActiveRecord::Base.connection.table_exists?(:colors)
        drop_table :colors
      end
    end
  end
  