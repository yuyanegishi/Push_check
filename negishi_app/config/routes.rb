Rails.application.routes.draw do
  get 'orders/new'
  get 'cart_items/index'
  get 'addresses/new'
  get 'sessions/new'
  root 'books#index'
  get 'static_pages/help'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/exhibit', to: 'books#new'
  get '/registration', to: 'addresses#new'
  resources :users
  resources :books
  resources :addresses
  resources :cart_items
  resources :orders
  resources :order_items
end
