Rails.application.routes.draw do


  resources :github do
      post :repo, on: :collection
      delete :repo, on: :collection, to: "github#delete_repos"
  end

  post "commit", to: "github#random_commit", as: :random_commit

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth'}
  root to: "pages#home"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
