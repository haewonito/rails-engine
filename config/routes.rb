Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, controller: "merchant_items", only: [:index]
      end
      resources :items, only: [:index, :show, :create]
    end
  end


end



# api/v1/merchants/:merchant_id/items
# api/v1/items

# get "/api/v1/merchants/:merchant_id/items", to: "merchant_items#index"
# get "/api/v1/items", to: "items#index"
