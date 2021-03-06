Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      namespace :merchants do
        get '/:id/items', to: 'items#index'
        get '/find', to: 'search#show'
        get '/find_all',to: 'search#index'
        get '/most_revenue', to: 'revenue#index'
        get '/most_items', to: 'revenue#index'
        get ':id/revenue', to: 'revenue#show'
      end

      namespace :items do
        get '/:id/merchant', to: 'merchants#show'
        get '/find', to: 'search#show'
        get '/find_all',to: 'search#index'
      end

      resources :merchants
      resources :items
      resources :revenue, only: [:index]
    end
  end
end
