Rails.application.routes.draw do

  resources :blogs do
    resources :posts
  end

end
