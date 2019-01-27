Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "url/new", to: "urls#new"
  post "url/new", to: "urls#create"

  get "url/:id", to: "urls#show"

  root 'urls#new'
end
