require 'rails_helper'

RSpec.describe AnagramsPresenter, type: :model do
  describe '#helper methods' do

    before(:each) do
      @ap = AnagramsPresenter.new
      @ap.extend(ApplicationHelper)
    end

    context "#capitalized?" do
      it 'should return true if word is capitalized' do
        word = "Word"

        expect(@ap.capitalized?(word)).to eq(true)
      end
    end

    context "#delete_capitalized_words" do
      it 'should delete capitalized words from array' do
        words = ["one", "two", "Three", "Four"]
        without_pn = ["one", "two"]

        expect(@ap.delete_capitalized_words(words)).to eq(without_pn)
      end
    end

  end
end
