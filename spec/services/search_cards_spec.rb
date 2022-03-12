# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe SearchCards do
  subject { described_class.new(options).call }

  describe 'filter by set' do
    let(:options) do
      { filter_set: '2XM' }
    end

    let!(:valid_card) { create(:card, set: '2XM') }
    let!(:invalid_card) { create(:card, set: 'KTK') }

    it 'returns the cards with the given set' do
      expect(subject.data).to match_array(valid_card)
    end
  end

  describe 'filter by color' do
    context 'filter by a single color' do
      let(:options) do
        { filter_colors: ['Blue'] }
      end

      let(:blue) { create(:color, name: 'Blue') }
      let(:green) { create(:color, name: 'Green') }

      let!(:valid_card) { create(:card) }
      let!(:invalid_card) { create(:card) }

      before do
        valid_card.colors << blue
        invalid_card.colors << green
      end

      it 'returns the cards with the given color' do
        expect(subject.data).to match_array(valid_card)
      end
    end

    context 'filter by two colors' do
      let(:options) do
        { filter_colors: %w[Blue White] }
      end

      let(:blue) { create(:color, name: 'Blue') }
      let(:white) { create(:color, name: 'White') }
      let(:green) { create(:color, name: 'Green') }

      let!(:valid_card) { create(:card) }
      let!(:more_than_two_colors) { create(:card) }
      let!(:blue_only_card) { create(:card) }
      let!(:white_only_card) { create(:card) }

      before do
        valid_card.colors << blue
        valid_card.colors << white
        more_than_two_colors.colors << blue
        more_than_two_colors.colors << white
        more_than_two_colors.colors << green
        blue_only_card.colors << blue
        white_only_card.colors << white
      end

      it 'returns the cards that ONLY have the two colors' do
        expect(subject.data).to match_array(valid_card)
      end
    end
  end

  describe 'filter by set and color' do
    let(:options) do
      {
        filter_set: '2XM',
        filter_colors: %w[Blue White]
      }
    end

    let(:blue) { create(:color, name: 'Blue') }
    let(:white) { create(:color, name: 'White') }

    let!(:valid_card) { create(:card, set: '2XM') }
    let!(:invalid_card) { create(:card, set: 'KTK') }
    let!(:white_only_card) { create(:card, set: '2XM') }

    before do
      valid_card.colors << blue
      valid_card.colors << white
      invalid_card.colors << blue
      invalid_card.colors << white
      white_only_card.colors << white
    end

    it 'returns the cards with the valid set and colors' do
      expect(subject.data).to match_array(valid_card)
    end
  end

  describe 'group cards by set' do
    let(:options) do
      { groups: [:set] }
    end

    let!(:card_2xm) { create(:card, set: '2XM') }
    let!(:card_ktk) { create(:card, set: 'KTK') }

    it 'returns the cards grouped by set' do
      expect(subject.data).to include(
        {
          ['2XM'] => [card_2xm],
          ['KTK'] => [card_ktk]
        }
      )
    end
  end

  describe 'group cards by set and rarity' do
    let(:options) do
      { groups: %i[set rarity] }
    end

    let!(:card_2xm_common) { create_list(:card, 2, set: '2XM', rarity: 'Common') }
    let!(:card_ktk_uncommon) { create_list(:card, 3, set: 'KTK', rarity: 'Uncommon') }
    let!(:card_ktk_common) { create_list(:card, 2, set: 'KTK', rarity: 'Common') }

    it 'returns the cards grouped by set and rarity within each set' do
      expect(subject.data).to include(
        {
          %w[2XM Common] => card_2xm_common,
          %w[KTK Common] => card_ktk_common,
          %w[KTK Uncommon] => card_ktk_uncommon
        }
      )
    end
  end

  describe 'pagination' do
    let(:options) do
      { filter_set: '2XM' }
    end

    let!(:valid_cards) { create_list(:card, 23, set: '2XM') }

    it 'returns the first page results' do
      expect(subject.data).to match_array(valid_cards.first(10))
    end

    describe 'requesting the second page' do
      let(:options) do
        {
          filter_set: '2XM',
          page: 2
        }
      end

      it 'returns the second page results' do
        expect(subject.data).to match_array(valid_cards.drop(10).first(10))
      end
    end
  end
end
