require 'rails_helper'

RSpec.describe WordsPresenter, type: :module do
  describe 'Class Methods' do
    it '.analytics' do
      Word.create(word: "abc")
      Word.create(word: "abcd")
      Word.create(word: "abcde")
      Word.create(word: "abcde")
      Word.create(word: "abcdef")
      Word.create(word: "abcdefg")
      Word.create(word: "abcdefgh")

      wp = WordsPresenter.new

      expect(wp.analytics).to be_a(Hash)
      expect(wp.analytics).to have_key(:total_word_count)
      expect(wp.analytics).to have_key(:shortest_word)
      expect(wp.analytics).to have_key(:longest_word)
      expect(wp.analytics).to have_key(:avg_word_length)
      expect(wp.analytics).to have_key(:median_word_length)
      expect(wp.analytics[:total_word_count]).to eq(6)
      expect(wp.analytics[:shortest_word]).to eq(3)
      expect(wp.analytics[:longest_word]).to eq(8)
      expect(wp.analytics[:avg_word_length]).to eq(0.55e1)
    end
  end
end
