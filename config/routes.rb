Rails.application.routes.draw do
  root to: 'inventories#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  get 'department/edit', to: 'users#edit_department', as: :edit_department
  patch 'department/update', to: 'users#update_department', as: :update_department

  resources :departments do
    member do
      get :delete
    end
  end

  resources :inventories do
    collection do
      delete :multi_delete
    end
  end
  resources :items, only: [:new, :create]
  # resources :users, as: :app_users, path: '/app_users', param: :email, format: false, constraints: { email: /[^\/]+/ }

  resources :categories, param: :cat_id do
    member do
      get 'delete'
    end
  end
  
end