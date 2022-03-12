# frozen_string_literal: true

require_relative '../models/card'
require_relative '../models/cards_color'
require_relative '../models/color'

class CardsImporter
  attr_reader :json_deck

  def initialize(json_deck:)
    @json_deck = json_deck
  end

  def import!
    import_colors!
    deck = generate_deck_attributes(colors_map: build_colors_mapping)
    Card.create(deck)
  end

  private

  def import_colors!
    unique_colors = json_deck
                    .map { |c| c[:colors] }
                    .flatten
                    .uniq
                    .compact
                    .map { |c| { name: c } }

    Color.upsert_all(unique_colors, unique_by: :name)
  end

  def build_colors_mapping
    Color.all.each_with_object({}) do |i, hash|
      hash[i.name] = i.id
    end
  end

  def generate_deck_attributes(colors_map:)
    json_deck.map do |card|
      attributes = generate_card_attributes(card)

      if card[:colors]
        attributes[:cards_colors_attributes] = card[:colors].map do |c|
          { color_id: colors_map[c] }
        end
      end

      attributes
    end
  end

  def generate_card_attributes(card)
    {
      name: card[:name],
      set: card[:set],
      rarity: card[:rarity]
    }
  end
end
