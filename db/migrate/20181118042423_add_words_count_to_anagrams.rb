class AddWordsCountToAnagrams < ActiveRecord::Migration[5.2]
  def change
    add_column :anagrams, :words_count, :int, default: 0
  end
end
