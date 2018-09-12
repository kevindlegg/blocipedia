Rails.application.routes.draw do
  get 'charges/new'
  devise_for :users
  resources :wikis
  
  get 'about' => 'welcome#about'
  root 'welcome#index'
end
