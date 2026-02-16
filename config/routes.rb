Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }

  root "home#index"

  resources :products do
    collection do
      post :sync_to_sheet, to: "products_sync#sync_to_sheet"
      post :sync_from_sheet, to: "products_sync#sync_from_sheet"
    end

    member do
      delete :hard_delete
    end
  end

  namespace :api, defaults: { format: :json } do
    resources :products
  end
end
