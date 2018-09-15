Rails.application.routes.draw do
  get 'user/start'
  get 'user/new'
  get 'user/remove'
  get 'user/login'
  get 'user/logout'
  get 'user/profile'
  get 'user/index'
  get 'user/edit'
  get 'user/message'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'user#start'
  post "user/new" => "user#new"
  post "user/login" => "user#login"
  post "user/edit" => "user#edit"
  post "user/index" => "user#index"
  post "user/message" => "user#message"
  post "user/profile" => "user#profile"

resources :user
end
