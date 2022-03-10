# frozen_string_literal: true

require 'yaml'
require 'active_record'
require 'pry'

class Connection
  attr_reader :db_config

  def initialize
    db_config_file = File.open('lib/db/database.yml')
    @db_config = YAML.safe_load(db_config_file)
  end

  def connect
    ActiveRecord::Base.establish_connection(@db_config)
  end
end
