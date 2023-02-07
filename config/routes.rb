Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show], module: :merchants do
        resources :items, only: :index
      end
      resources :items, only: [:index, :show, :create, :destroy, :update], module: :items do
        get '/merchant', to: 'merchants#show'
      end
    end
  end
end
