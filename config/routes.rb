Rails.application.routes.draw do
  post '/words', to: "words#create"
  get '/anagrams/:slug', to: "anagrams#show"
  delete '/words/:slug', to: "words#destroy"
  delete '/words', to: "words#destroy"
end
