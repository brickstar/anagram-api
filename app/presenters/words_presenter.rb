class WordsPresenter
  def analytics
    {
      total_word_count: Word.analytics.first.total_word_count,
      shortest_word: Word.analytics.first.shortest_word,
      longest_word: Word.analytics.first.longest_word,
      avg_word_length: Word.analytics.first.avg_word_length.to_f.round(2),
      median_word_length: Word.median_word_length
    }
  end
end
