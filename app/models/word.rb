class Word < ApplicationRecord
  validates :word, presence: true, uniqueness: true
  belongs_to :anagram, optional: true
end
