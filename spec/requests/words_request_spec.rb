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
      word_3 = Word.create(word: "dear", anagram: anagram)

      get "/anagrams/#{word_1.word}.json"

      expect(response).to be_successful

      response = JSON.parse(body, symbolize_names: true)
      words = response[:anagrams]

      expect(response).to have_key(:anagrams)
      expect(words).to be_a(Array)
      expect(words.length).to eq(2)
    end
  end

  describe "GET /anagrams/:word.json, limit=1" do
    it "should return a JSON array of anagrams limited for :word" do
      anagram = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram)
      word_2 = Word.create(word: "dare", anagram: anagram)
      word_3 = Word.create(word: "dear", anagram: anagram)

      get "/anagrams/#{word_1.word}.json?limit=1"

      expect(response).to be_successful

      response = JSON.parse(body, symbolize_names: true)

      words = response[:anagrams]

      expect(response).to have_key(:anagrams)
      expect(words).to be_a(Array)
      expect(words.length).to eq(1)
    end
  end

  describe "DELETE /words/:word.json" do
    it "should delete specified word from dataset" do
      anagram = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram)
      word_2 = Word.create(word: "dare", anagram: anagram)
      word_3 = Word.create(word: "dear", anagram: anagram)

      expect(Word.all.count).to eq(3)

      delete "/words/#{word_1.word}.json"

      expect(response.status).to eq(204)
      expect(Word.all.count).to eq(2)
    end
  end

  describe "DELETE /words.json" do
    it "should delete entire dataset" do
      anagram = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram)
      word_2 = Word.create(word: "dare", anagram: anagram)
      word_3 = Word.create(word: "dear", anagram: anagram)

      expect(Word.all.count).to eq(3)

      delete "/words.json"

      expect(response.status).to eq(204)
      expect(Word.all.count).to eq(0)
      expect(Anagram.all.count).to eq(0)
    end
  end

  describe 'GET /anagrams/size=x' do
    it 'should return all anagram groups of size >= x' do
      anagram_1 = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram_1)
      word_2 = Word.create(word: "dare", anagram: anagram_1)
      word_3 = Word.create(word: "dear", anagram: anagram_1)

      anagram_2 = Anagram.create(anagram: "aehm")
      word_4 = Word.create(word: "hame", anagram: anagram_2)
      word_5 = Word.create(word: "haem", anagram: anagram_2)
      word_6 = Word.create(word: "ahem", anagram: anagram_2)

      anagram_3 = Anagram.create(anagram: "akos")
      word_7 = Word.create(word: "soka", anagram: anagram_3)
      word_8 = Word.create(word: "soak", anagram: anagram_3)
      word_9 = Word.create(word: "asok", anagram: anagram_3)

      anagram_4 = Anagram.create(anagram: "aaeglr")
      word_10 = Word.create(word: "laager", anagram: anagram_4)
      word_11 = Word.create(word: "galera", anagram: anagram_4)
      word_12 = Word.create(word: "alegar", anagram: anagram_4)
      word_13 = Word.create(word: "aglare", anagram: anagram_4)

      anagram_5 = Anagram.create(anagram: "chipty")
      word_14 = Word.create(word: "typhic", anagram: anagram_5)
      word_15 = Word.create(word: "pythic", anagram: anagram_5)
      word_16 = Word.create(word: "pitchy", anagram: anagram_5)
      word_17 = Word.create(word: "phytic", anagram: anagram_5)

      get "/word-group-size.json?limit=#{anagram_1.words.count}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response = JSON.parse(body, symbolize_names: true)
      expect(response).to be_a(Array)
      expect(response.count).to eq(2)
      expect(response[0]).to have_key(:words_count)
      expect(response[0]).to have_key(:words)
      expect(response[0][:words]).to be_a(Array)
    end
  end

end
