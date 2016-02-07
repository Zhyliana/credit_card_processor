CreditCardProcessor::Application.routes.draw do
  root to: 'credit_cards#index'
  namespace :api do
    resources :credit_cards
    resources :transactions
  end
end