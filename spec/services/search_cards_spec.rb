# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe SearchCards do

  subject { described_class.new(options).call }

  describe 'filter by set' do
    let(:options) do
      { filter_set: "2XM"}
    end

    let!(:valid_card) { create(:card, set: "2XM") }
    let!(:invalid_card) { create(:card, set: "KTK") }

    it 'returns the cards with the given set' do
      expect(subject).to match_array(valid_card)
    end
  end

  describe 'filter by color' do
    context 'filter by a single color' do
      let(:options) do
        { filter_colors: ["Blue"]}
      end

      let(:blue) { create(:color, name: "Blue") }
      let(:green) { create(:color, name: "Green") }

      let!(:valid_card) { create(:card) }
      let!(:invalid_card) { create(:card) }

      before do
        valid_card.colors << blue
        invalid_card.colors << green
      end

      it 'returns the cards with the given color' do
        expect(subject).to match_array(valid_card)
      end
    end
    
    context 'filter by two colors' do
      let(:options) do
        { filter_colors: ["Blue", "White"] }
      end

      let(:blue) { create(:color, name: "Blue") }
      let(:white) { create(:color, name: "White") }

      let!(:valid_card) { create(:card) }
      let!(:blue_only_card) { create(:card) }
      let!(:white_only_card) { create(:card) }

      before do
        valid_card.colors << blue
        valid_card.colors << white
        blue_only_card.colors << blue
        white_only_card.colors << white
      end

      it 'returns the cards with that have the two colors' do
        expect(subject).to match_array(valid_card)
      end
    end
  end

  describe 'filter by set and color' do
    let(:options) do
      { 
        filter_set: "2XM",
        filter_colors: ["Blue", "White"],
      }
    end

    let(:blue) { create(:color, name: "Blue") }
    let(:white) { create(:color, name: "White") }

    let!(:valid_card) { create(:card, set: "2XM") }
    let!(:invalid_card) { create(:card, set: "KTK") }
    let!(:white_only_card) { create(:card, set: "2XM") }

    before do
      valid_card.colors << blue
      valid_card.colors << white
      invalid_card.colors << blue
      invalid_card.colors << white
      white_only_card.colors << white
    end

    it 'returns the cards with the valid set and colors' do
      expect(subject).to match_array(valid_card)
    end
  end
end
