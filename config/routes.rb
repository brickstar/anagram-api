Rails.application.routes.draw do
  post '/words.json', to: "words#create"
end
