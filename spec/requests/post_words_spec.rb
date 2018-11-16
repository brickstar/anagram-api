require 'rails_helper'

describe "POST /words.json" do
  it "should add words to corpus" do
    params = { "words": ["read", "dear", "dare"] }
    words = params[:words]

    expect(Word.all.count).to eq(0)
    
    post "/words.json", params: params

    expect(Word.all.count).to eq(3)
    expect(Word.pluck(:word)).to eq(words)
  end

end
