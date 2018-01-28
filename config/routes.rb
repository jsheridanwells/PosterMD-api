Rails.application.routes.draw do

  resources :blogs do
    resources :posts
  end

  post 'auth/login', to: 'authentication#authenticate'
  post '/signup', to: 'users#create'

end
