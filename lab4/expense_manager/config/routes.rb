Rails.application.routes.draw do
  resources :categories

  resources :expenses do
    collection do
      get :paid
    end
  end

  root "expenses#index"
end
