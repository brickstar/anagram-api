require "rails_helper"

RSpec.describe Word, type: :model do
  describe 'Class Methods' do
    it '.analytics' do
      word_1 = Word.create(word: "abc")
      word_2 = Word.create(word: "abcd")
      word_3 = Word.create(word: "abcde")

      total_word_count = Word.analytics.first.total_word_count
      shortest_word = Word.analytics.first.shortest_word
      longest_word = Word.analytics.first.longest_word
      avg_word_length = Word.analytics.first.avg_word_length

      expect(Word.analytics).to be_a(Array)
      expect(total_word_count).to eq(3)
      expect(shortest_word).to eq(3)
      expect(longest_word).to eq(5)
      expect(total_word_count).to eq(3)
    end
  end
end
