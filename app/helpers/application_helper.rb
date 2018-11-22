module ApplicationHelper
  def capitalized?(word)
    word == word.capitalize
  end

  def delete_capitalized_words(word_array)
    word_array.delete_if { |word| capitalized?(word) }
  end

end
