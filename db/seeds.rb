Word.delete_all
Anagram.delete_all

raw_dictionary = File.read('dictionary.xml')

anagram_hash = raw_dictionary.downcase.split.each_with_object(Hash.new []) do |word, hash|
  hash[word.chars.sort.join] += [word] if word.length > 1
end

anagram_hash.map.with_index do |anagram, index|
  new_anagram = Anagram.create!(anagram: anagram[0]) if index % 50 == 0
  anagram[1].each do |word|
    Word.create(word: word, anagram: new_anagram) if index % 50 == 0
  end
end
