Rails.application.routes.draw do
  post '/words', to: "words#create"
  delete '/words/:word', to: "words#destroy"
  delete '/words', to: "words#destroy"
  get '/word-group-size', to: "word_group_size#index"
  get '/anagrams/:word', to: "anagrams#show"
  get '/words-with-most-anagrams', to: "most_anagrams#index"
  delete '/delete-anagrams-for-word/:word', to:"anagram_words#destroy"
end
