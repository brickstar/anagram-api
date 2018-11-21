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
      expect(response[0]).to have_key(:anagrams_count)
      expect(response[0]).to have_key(:words)
      expect(response[0][:words]).to be_a(Array)
    end
  end

  describe 'GET /anagrams/size=x?proper_nouns=false' do
    it 'should return all anagram groups of size >= x without proper nouns' do
      anagram_1 = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram_1)
      word_2 = Word.create(word: "Dare", anagram: anagram_1)
      word_3 = Word.create(word: "dear", anagram: anagram_1)

      anagram_2 = Anagram.create(anagram: "aehm")
      word_4 = Word.create(word: "hame", anagram: anagram_2)
      word_5 = Word.create(word: "haem", anagram: anagram_2)
      word_6 = Word.create(word: "Ahem", anagram: anagram_2)

      anagram_3 = Anagram.create(anagram: "akos")
      word_7 = Word.create(word: "soka", anagram: anagram_3)
      word_8 = Word.create(word: "soak", anagram: anagram_3)
      word_9 = Word.create(word: "Asok", anagram: anagram_3)

      anagram_4 = Anagram.create(anagram: "aaeglr")
      word_10 = Word.create(word: "Laager", anagram: anagram_4)
      word_11 = Word.create(word: "galera", anagram: anagram_4)
      word_12 = Word.create(word: "alegar", anagram: anagram_4)
      word_13 = Word.create(word: "aglare", anagram: anagram_4)

      anagram_5 = Anagram.create(anagram: "chipty")
      word_14 = Word.create(word: "typhic", anagram: anagram_5)
      word_15 = Word.create(word: "pythic", anagram: anagram_5)
      word_16 = Word.create(word: "Pitchy", anagram: anagram_5)
      word_17 = Word.create(word: "phytic", anagram: anagram_5)

      get "/word-group-size.json?limit=#{anagram_1.words.count}&proper_nouns=false"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response = JSON.parse(body, symbolize_names: true)
      expect(response).to be_a(Array)
      expect(response.count).to eq(2)
      expect(response[0]).to have_key(:anagrams_count)
      expect(response[0]).to have_key(:words)
      expect(response[0][:words]).to be_a(Array)
    end
  end

  describe "DELETE /delete-anagrams-of-word/:word" do
    it "should delete the word and all its anagrams" do
      anagram = Anagram.create(anagram: "akos")
      word_1 = Word.create(word: "soka", anagram: anagram)
      word_2 = Word.create(word: "soak", anagram: anagram)
      word_3 = Word.create(word: "asok", anagram: anagram)

      expect(Anagram.count).to eq(1)
      expect(Word.count).to eq(3)

      delete "/delete-anagrams-for-word/#{word_1.word}"

      expect(Anagram.count).to eq(0)
      expect(Word.count).to eq(0)
    end
  end

  describe "GET /words-with-most-anagrams" do
    it "should return words with most anagrams" do
      anagram_1 = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram_1)
      word_2 = Word.create(word: "dare", anagram: anagram_1)
      word_3 = Word.create(word: "dear", anagram: anagram_1)

      anagram_2 = Anagram.create(anagram: "aehm")
      word_4 = Word.create(word: "hame", anagram: anagram_2)
      word_5 = Word.create(word: "haem", anagram: anagram_2)
      word_6 = Word.create(word: "ahem", anagram: anagram_2)

      anagram_3 = Anagram.create(anagram: "abg")
      word_7 = anagram_3.words.create(word: "bag")
      word_8 = anagram_3.words.create(word: "gab")

      get "/words-with-most-anagrams"

      expect(response).to be_successful

      response = JSON.parse(body, symbolize_names: true)

      expect(response).to have_key(:word_count)
      expect(response).to have_key(:words)
      expect(response[:word_count]).to eq(3)
      expect(response[:words]).to eq([["read", "dare", "dear"], ["hame", "haem", "ahem"]])
    end
  end

  describe "GET /words-with-most-anagrams?proper_nouns=false" do
    it "should return words with most anagrams without proper nouns" do
      anagram_1 = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram_1)
      word_2 = Word.create(word: "Dare", anagram: anagram_1)
      word_3 = Word.create(word: "dear", anagram: anagram_1)

      anagram_2 = Anagram.create(anagram: "aehm")
      word_4 = Word.create(word: "hame", anagram: anagram_2)
      word_5 = Word.create(word: "haem", anagram: anagram_2)
      word_6 = Word.create(word: "Ahem", anagram: anagram_2)

      anagram_3 = Anagram.create(anagram: "abg")
      word_7 = anagram_3.words.create(word: "bag")
      word_8 = anagram_3.words.create(word: "gab")

      get "/words-with-most-anagrams.json?proper_nouns=false"

      expect(response).to be_successful

      response = JSON.parse(body, symbolize_names: true)

      expect(response).to have_key(:word_count)
      expect(response).to have_key(:words)
      expect(response[:word_count]).to eq(2)
      expect(response[:words]).to eq([["read", "dear"], ["hame", "haem"]])
    end
  end

  describe "GET /words-analytics" do
    it "should return count of words and min/max/median/average word length" do
      word_1 = Word.create(word: "abcd")
      word_2 = Word.create(word: "abcde")
      word_3 = Word.create(word: "abcdef")

      get '/words-analytics'

      expect(response).to be_successful

      response = JSON.parse(body, symbolize_names: true)

      expect(response).to have_key(:total_word_count)
      expect(response).to have_key(:shortest_word)
      expect(response).to have_key(:longest_word)
      expect(response).to have_key(:avg_word_length)
    end
  end

  describe "GET /anagrams/:word.json?proper_nouns=false" do
    it "should not return proper nouns" do
      anagram = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "Read", anagram: anagram)
      word_2 = Word.create(word: "dare", anagram: anagram)
      word_3 = Word.create(word: "dear", anagram: anagram)

      get "/anagrams/dare.json?proper_nouns=false"

      response = JSON.parse(body, symbolize_names: true)

      expect(response[:anagrams]).to eq(["dear"])
      expect(response[:anagrams].include?("Read")).to eq(false)
    end
  end

  describe "GET /check-anagrams" do
    it "should validate anagrams" do
      anagram_1 = Anagram.create(anagram: "ader")
      word_1 = Word.create(word: "read", anagram: anagram_1)
      word_2 = Word.create(word: "dare", anagram: anagram_1)
      word_3 = Word.create(word: "dear", anagram: anagram_1)

      get '/check-anagrams'

      response = JSON.parse(resposne.body, symbolize_names: true)
      
      expect(response[:anagrams?]).to eq(true)
    end
  end
end
