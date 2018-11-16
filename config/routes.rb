Rails.application.routes.draw do
  post '/words.json', to: "words#create"
  resources :anagrams, param: :slug
end
