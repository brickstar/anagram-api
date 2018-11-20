class Word < ApplicationRecord
  validates :word, presence: true, uniqueness: true
  belongs_to :anagram, optional: true, counter_cache: true

  def self.analytics
    find_by_sql("SELECT MAX(char_length(word)) AS longest_word,
                 MIN(char_length(word)) AS shortest_word,
                 AVG(char_length(word)) AS avg_word_length,
                 COUNT(words.id) AS total_word_count FROM words")
  end
end
