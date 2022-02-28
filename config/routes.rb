Rails.application.routes.draw do
  devise_for :users
  resources :images, only: [:index, :create, :show, :edit, :update, :destroy]
  resources :tags

  unauthenticated do
    devise_scope :user do
      root "devise/sessions#new"
    end
  end

  authenticated :user do
    root 'images#index', as: :authenticated_root
  end
end
