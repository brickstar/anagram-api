require 'rails_helper'

describe "POST /words.json" do
  it "should add words to corpus" do
    post '/words.json' do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = '{ "name": "Jane", "age": 17 }'
    end
  end
  
end
