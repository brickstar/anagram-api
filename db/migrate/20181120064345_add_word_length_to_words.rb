class AddWordLengthToWords < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :word_length, :integer
  end
end
