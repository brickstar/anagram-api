class AnagramFinder
  def initialize(word)
    @word = word
  end

  def find_anagrams
    Anagram.includes(:words)
    .find_by(anagram: @word.downcase.chars.sort.join)
    .words
    .pluck(:word)
  end
end
