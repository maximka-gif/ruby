Rails.application.routes.draw do
  resources :categories
  resources :payment_methods, only: [:create, :destroy]

  resources :expenses do
    collection do
      get :paid
      get :this_month
    end
  end

  root "expenses#index"
end