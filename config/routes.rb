Rails.application.routes.draw do
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'users'  => 'users#index'
  get    'search'  => 'users#search'
  post   'result'  => 'users#result'
  get    'search_result'  => 'users#search_result'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
      get :requesting, :requesters
    end
  end
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :requests,            only: [:create, :destroy]
  #match ':controller(/:action(/:id))',via => :get
end
