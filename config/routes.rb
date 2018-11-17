Rails.application.routes.draw do
  post '/words', to: "words#create"
  delete '/words/:slug', to: "words#destroy"
  get '/anagrams/:slug', to: "anagrams#show"
end
