# Rakefile
require 'active_record'

namespace :migrate do
  task :setup do
    require_relative 'lib/db/connection'
    require_relative 'lib/db/migrations/create_cards_table'

    Connection.new.connect
    CreateCardsTable.migrate(:up)
  end

  task :drop do
    require_relative 'lib/db/connection'
    require_relative 'lib/db/migrations/create_cards_table'

    Connection.new.connect
    CreateCardsTable.migrate(:down)
  end
end