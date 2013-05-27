Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :store_credits
    resources :store_credit_reasons
    resources :store_credit_types
    resources :users do
      resources :store_credits
    end
  end
end
