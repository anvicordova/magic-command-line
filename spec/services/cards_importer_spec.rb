# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../fixtures/deck'

RSpec.describe CardsImporter do
  subject { described_class.new(json_deck:) }

  let(:json_deck) { DECK }

  describe 'import!' do
    it 'imports the colors' do
      subject.import!
      expect(Color.count).to eq 3
    end

    it 'imports the cards' do
      subject.import!
      expect(Card.count).to eq 100
    end
  end
end
