Rails.application.routes.draw do
     root to: 'inventories#index'

     devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
     devise_scope :user do
          get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
          get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
          get 'users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
     end

     patch 'toggle_role', to: 'users#toggle_role', as: :toggle_role
     get 'department/edit', to: 'users#edit_department', as: :edit_department
     patch 'department/update', to: 'users#update_department', as: :update_department

     resources :users do
          collection do
            get :search
          end
        end
        

     get '/settings/accessibility', to: 'settings#accessibility', as: 'accessibility_settings'

     get 'users/search', to: 'users#search'


     resources :whitelists do
          member do
               get :delete
          end
     end

     resources :departments do
          member do
               get :delete
          end
     end

     resources :inventories do
          collection do
               delete :multi_delete
               post :bulk_checkout
               post :bulk_return
               post :bulk_update
          end

          member do
               post :checkout
               post :return
          end
     end

     resources :transaction_histories, only: [:index] do
          collection do
            get 'for_inventory/:inventory_id', to: 'transaction_histories#index', as: :for_inventory
          end
        end

     resources :items do
          member do
               get :delete
          end
     end

     resources :categories, param: :cat_id do
          member do
               get 'delete'
          end
     end
end