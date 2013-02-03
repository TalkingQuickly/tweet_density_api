Tstream::Application.routes.draw do
  get "tags/index"

  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  namespace :api do
    namespace :v1 do
      resources :tweet_densities, only: [:show]
      resources :tags, only: [:index]
    end
  end
end
