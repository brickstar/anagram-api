require 'rails_helper'

describe "Anagrams API" do

  describe "POST /words.json" do
    it "should add words to corpus" do
      params = { "words": ["read", "dear", "dare"] }
      words = params[:words]

      expect(Word.all.count).to eq(0)

      post "/words.json", params: params

      expect(response).to be_successful
      expect(Word.all.count).to eq(3)
      expect(Word.pluck(:word)).to eq(words)
    end
  end

  describe "GET /anagrams/:word.json" do
    it "should return a JSON array of anagrams for :word" do
      anagram = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram)
      word_2 = Word.create(word: "dare", anagram: anagram)
      word_2 = Word.create(word: "dear", anagram: anagram)

      get "/anagrams/#{word_1.word}.json"

      expect(response).to be_successful

      response = JSON.parse(body, symbolize_names: true)
      words = response[:anagrams]

      expect(response).to have_key(:anagrams)
      expect(words).to be_a(Array)
      expect(words.length).to eq(2)
    end
  end

end
