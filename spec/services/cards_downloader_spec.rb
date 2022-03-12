# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe CardsDownloader do
  subject { described_class.new(pool_size: 1) }

  describe 'download' do
    it 'fetches and saves the cards' do
      VCR.use_cassette('cards') do
        allow(subject).to receive(:thread_executor).and_return(1)
        expect do
          subject.download!
        end.to change { Card.count }.by(100)
      end
    end
  end
end
