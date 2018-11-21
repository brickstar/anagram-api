Rails.application.routes.draw do
  get '/words-analytics', to: "word_analytics#index"
  get '/anagrams/:word', to: "anagrams#show"
  get '/word-group-size', to: "word_group_size#index"
  get '/words-with-most-anagrams', to: "most_anagrams#index"
  get '/check-anagrams', to: "check_anagrams#show"
  post '/words', to: "words#create"
  delete '/delete-anagrams-for-word/:word', to:"anagram_words#destroy"
  delete '/words/:word', to: "words#destroy"
  delete '/words', to: "words#destroy"
end
