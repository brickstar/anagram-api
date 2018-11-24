module ProperNounWordGroupSize
  include ApplicationHelper
  def delete_proper_nouns
    if params[:proper_nouns] == "false"
      render json: words_without_proper_nouns, status: 200
    end
  end

  def get_anagrams_by_word_group_size
    AnagramsPresenter.new.by_word_group_size(params[:limit])
  end

  def words_without_proper_nouns
    get_anagrams_by_word_group_size.reduce(Array.new) do |ary, element, hash = Hash.new([])|
      hash[:anagrams_count] = element[:anagrams_count]
      hash[:words] = element[:words].to_a.flatten.each_slice(element[:anagrams_count]).map { |ary| delete_capitalized_words(ary)}
      ary << hash
      ary
    end
  end
end
