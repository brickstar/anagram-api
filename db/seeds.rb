Word.delete_all
Anagram.delete_all

# Zlib::GzipReader.open('dictionary.txt.gz') do | input_stream |
#   File.open("dictionary.txt", "w") do |output_stream|
#     IO.copy_stream(input_stream, output_stream)
#   end
# end

raw_dictionary = File.read('dictionary.txt')
anagram_hash = raw_dictionary.downcase.split.each_with_object(Hash.new []) do |word, hash|
  hash[word.chars.sort.join.downcase] += [word] if word.length > 1
end

anagram_hash.map.with_index do |anagram, index|
  new_anagram = Anagram.create(anagram: anagram[0]) if index % 50 == 0
  anagram[1].each do |word|
    Word.create(word: word, word_length: word.length, anagram: new_anagram) if index % 50 == 0
  end
end

anagram = Anagram.find_or_create_by(anagram: "dog".chars.sort.join)
anagram.words.create(word: "dog", word_length: 3)
anagram.words.create(word: "God", word_length: 3)
