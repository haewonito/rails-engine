Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/api/v1/merchants/find", to: "api/v1/merchant_search#index"
  get "/api/v1/items/find", to: "api/v1/items_search#index"

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, controller: "merchant_items", only: [:index]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, controller: "item_merchant", only: [:index]
      end
    end
  end




end



# api/v1/merchants/:merchant_id/items
# api/v1/items

# get "/api/v1/merchants/:merchant_id/items", to: "merchant_items#index"
# get "/api/v1/items", to: "items#index"
