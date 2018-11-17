Rails.application.routes.draw do
  post '/words.json', to: "words#create"
  get '/anagrams/:slug', to: "anagrams#show"
end
