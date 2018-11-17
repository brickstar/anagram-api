class Anagram < ApplicationRecord
  has_many :words

  def self.anagrams(params)
    {
      anagrams: includes(:words).find_by(anagram: params.chars.sort.join).words.pluck(:word).tap do |words|
                  words.delete(params)
                end
    }
  end
end
