class Anagram < ApplicationRecord
  has_many :words

  def self.anagrams(slug, limit = 0)
    if limit
      {
        anagrams: includes(:words).find_or_create_by(anagram: slug.chars.sort.join).words.pluck(:word).take(limit.to_i)
      }
    else
      {
        anagrams: includes(:words).find_or_create_by(anagram: slug.chars.sort.join).words.pluck(:word).tap do |words|
          words.delete(slug)
        end
      }
    end
  end
end
