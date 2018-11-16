require 'rails_helper'

describe "POST /words.json" do
  it "should add words to corpus" do

    expect(Word.all.count).to eq(0)

    params = { "words": ["read", "dear", "dare"] }

    post "/words.json", params: params

    expect(Word.all.count).to eq(3)
    binding.pry
  end

end
