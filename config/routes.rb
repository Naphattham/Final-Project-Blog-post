Rails.application.routes.draw do
  # หน้าแรก
  root "dashboard#index"

  # Dashboard
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'

  # Posts และ Nested Resources
    resources :posts, only: [:index, :show, :create, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy, :edit, :update]
    resources :likes, only: [:create, :destroy]
  end

  # Users
  resources :users, only: [:new, :create, :show] do
    member do
      post 'follow'   # สำหรับติดตามผู้ใช้
      delete 'unfollow' # สำหรับเลิกติดตามผู้ใช้
    end
  end

  # Profile
  get '/profile', to: 'users#profile', as: 'profile'

  # Authentication (เข้าสู่ระบบและออกจากระบบ)
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  # Suggested Users
  get '/suggested_users', to: 'users#suggested', as: 'suggested_users'
end
