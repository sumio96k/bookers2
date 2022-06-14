Rails.application.routes.draw do
  devise_for :users

  resources :books, only: [:index, :show, :create, :edit, :destroy]
  resources :users, only: [:show, :edit, :index, :update]
  root to: 'homes#top'
  get 'homes/about' => 'homes#about', as: 'about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
