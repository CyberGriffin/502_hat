Rails.application.routes.draw do
  root to: 'inventories#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
    get 'users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
  end

  patch 'toggle_role', to: 'users#toggle_role', as: :toggle_role

  resources :departments do
    member do
      get :delete
    end
  end

  resources :inventories
  resources :items
  # resources :users, as: :app_users, path: '/app_users', param: :email, format: false, constraints: { email: /[^\/]+/ }

  resources :categories, param: :cat_id do
    member do
      get 'delete'
    end
  end
  
end