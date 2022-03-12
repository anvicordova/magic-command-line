# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe CardsFetcher do
  subject { described_class.new }

  describe 'fetch' do
    it 'fetches the given page from the API' do
      VCR.use_cassette('fetch_card_page') do
        expect(subject.fetch(page: 1).count).to eq 100
      end
    end
  end

  describe 'page_metadata' do
    let(:metadata) do
      {
        total_pages: 65_597,
        cards_per_page: 100
      }
    end

    it 'returns the page metadata' do
      VCR.use_cassette('page_metadata') do
        expect(subject.page_metadata).to eq metadata
      end
    end
  end
end
