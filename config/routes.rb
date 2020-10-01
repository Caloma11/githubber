Rails.application.routes.draw do

  require "sidekiq/web"
  Sidekiq::Web.set :sessions, false
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :github do
      post :repo, on: :collection
      delete :repo, on: :collection, to: "github#delete_repos"
      post :manual, on: :collection, to: "github#manual_commit", as: :manual
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth'}
  root to: "pages#home"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
