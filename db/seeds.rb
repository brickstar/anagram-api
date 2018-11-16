# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Zlib::GzipReader.open('dictionary.txt.gz') do | input_stream |
  File.open("dictionary.xml", "w") do |output_stream|
    IO.copy_stream(input_stream, output_stream)
  end
end


#stringify dictionary
raw_dictionary = File.read('dictionary.xml')

#create anagram dataset
anagram_hash = raw_dictionary.downcase.split.each_with_object(Hash.new []) do |word, hash|
  hash[word.chars.sort.join] += [word] if word.length > 1
end

anagram_hash.map do |anagram|
  new_anagram = Anagram.create!(anagram: anagram[0])
  anagram[1].each do |word|
    Word.create(word: word, anagram: new_anagram)
  end
end
