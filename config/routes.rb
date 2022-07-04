Rails.application.routes.draw do
  get 'searches/search'
  devise_for :users

  resources :books, only: [:index, :show, :create, :edit, :update, :destroy] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :index, :update] do
    resource :relationships, only: [:create, :destroy]

      get 'followings_list' => 'relationships#followings_lists', as: 'followings'
      get 'followers_list' => 'relationships#followers_lists', as: 'followers'

  end

  get 'order' => 'orders#index', as: 'order'

  get 'search' => 'searches#search', as: 'search'
  get 'tags_search' => 'searches#tags_search', as: 'tags_search'

  resources :tags do
    get 'tag_search' => 'books#tag_search', as: 'tag_search'
  end

  root to: 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
