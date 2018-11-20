require 'rails_helper'

RSpec.describe WordsPresenter, type: :module do
  describe 'Class Methods' do
    it '.analytics' do
      word_1 = Word.create(word: "abc")
      word_2 = Word.create(word: "abcd")
      word_3 = Word.create(word: "abcde")

      wp = WordsPresenter.new

      expect(wp.analytics).to be_a(Hash)
      expect(wp.analytics[:total_word_count]).to eq(3)
      expect(wp.analytics[:shortest_word]).to eq(3)
      expect(wp.analytics[:longest_word]).to eq(5)
      expect(wp.analytics[:avg_word_length]).to eq(0.4e1)
    end
  end
end
