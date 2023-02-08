Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :items do
        get '/find', to: 'search#show'
      end
      namespace :merchants do
        get '/find_all', to: 'search#show'
      end
      resources :merchants, only: %i[index show], module: :merchants do
        resources :items, only: :index
      end
      resources :items, only: %i[index show create destroy update], module: :items do
        resource :merchant, only: :show
      end
    end
  end
end
