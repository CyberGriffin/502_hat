Rails.application.routes.draw do
  root to: 'inventories#index'

  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end

  resources :departments do
    member do
      get :delete
    end
  end

  resources :inventories do
    member do
      get :delete
    end
  end
  
  resources :users, param: :email, format: false, constraints: { email: /[^\/]+/ }
  resources :categories, param: :cat_id do
    member do
      get 'delete'
    end
  end
  
end