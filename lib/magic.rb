# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.development')

require 'optparse'
require_relative 'services/search_cards'
require_relative 'services/cards_downloader'

# magic -g set
# magic -g set,rarity
# magic -s KTK -c blue,red

@options = {
  page: 1
}

OptionParser.new do |opts|
  opts.on('-d', '--download', 'Downloads the cards from the API') do
    @options[:download] = true
  end

  opts.on('-gKEYS', '--group-by=KEYS', 'Group results by property') do |keys|
    @options[:groups] = keys.split(',').map(&:to_sym)
  end

  opts.on('-sSET', '--set=SET', 'Filter results by set') do |set|
    @options[:filter_set] = set
  end

  opts.on('-cCOLORS', '--color=COLORS', 'Filter results by colors') do |colors|
    @options[:filter_colors] = colors.split(',')
  end

  opts.on('-pNUMBER', '--page=NUMBER', 'Show this page for the results') do |page|
    @options[:page] = page.to_i
  end
end.parse!

if @options[:download]
  CardsDownloader.new.download!
elsif @options[:groups]
  results = SearchCards.new(@options).call

  results.each do |k, v|
    puts "GROUP: #{k.join(' - ')}"
    puts 'CARDS'
    puts v.pluck(:name).join("\n").to_s
    puts '-------------------'
  end
else
  results = SearchCards.new(@options).call

  puts 'Cards'
  puts '-------------------'
  puts results.pluck(:name)
end
