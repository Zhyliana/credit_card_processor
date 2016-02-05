CreditCardProcessor::Application.routes.draw do
  root to: 'application#home'
  resources :credit_cards
  resources :transactions
end