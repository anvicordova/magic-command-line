# Rakefile
require 'active_record'

namespace :migrate do
  task :setup do
    require_relative 'lib/db/connection'
    require_relative 'lib/db/migrations/create_cards_table'
    require_relative 'lib/db/migrations/create_colors_table'
    require_relative 'lib/db/migrations/create_cards_colors_table'

    Connection.new.connect
    CreateCardsTable.migrate(:up)
    CreateColorsTable.migrate(:up)
    CreateCardsColorsTable.migrate(:up)
  end

  task :drop do
    require_relative 'lib/db/connection'
    require_relative 'lib/db/migrations/create_cards_table'
    require_relative 'lib/db/migrations/create_colors_table'
    require_relative 'lib/db/migrations/create_cards_colors_table'

    Connection.new.connect
    CreateCardsTable.migrate(:down)
    CreateColorsTable.migrate(:down)
    CreateCardsColorsTable.migrate(:down)
  end
end