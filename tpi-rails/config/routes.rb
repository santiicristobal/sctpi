Rails.application.routes.draw do
  devise_for :users
  resources :professionals do
    resources :appointments
    
  end
  post 'professionals/grilla_day', to: "appointments#grilla_day"
  post 'professionals/grilla_week', to: "appointments#grilla_week" 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'professionals#index'
end
