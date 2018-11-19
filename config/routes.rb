Rails.application.routes.draw do
  post '/words', to: "words#create"
  delete '/words/:slug', to: "words#destroy"
  delete '/words', to: "words#destroy"
  get '/word-group-size', to: "word_group_size#index"
  get '/anagrams/:slug', to: "anagrams#show"
end
