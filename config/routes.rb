CreditCardProcessor::Application.routes.draw do
  root to: 'home#home'
  resources :credit_cards
end