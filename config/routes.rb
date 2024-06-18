Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, only: %i[show update]
  resources :interests, only: %i[new create destroy]
  resources :private_chatrooms, only: %i[index show create update] do
    resources :messages, only: :create
  end
  resources :groupchats, only: %i[index show] do
    resources :messages, only: :create
  end
  resources :friendships, only: %i[index new create update]
  get "search", to: "pages#search", as: :search_page

  get "profile", to: "pages#profile"
end
