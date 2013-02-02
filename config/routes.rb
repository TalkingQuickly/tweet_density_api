Tstream::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tweet_densities, only: [:show]
    end
  end
end
