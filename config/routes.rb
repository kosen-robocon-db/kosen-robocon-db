Rails.application.routes.draw do

  root 'static_pages#home'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  resources :users, only: [:index, :destroy] do
    member do
      get :approve, :unapprove
    end
  end

  resources :campuses, only: [:index, :show], param: :code
  resources :contests, only: [:index, :show], param: :nth
  # resources :contest_entries, only: [:index]
  resource :statistics, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      get 'home'
    end
  end
  resources :robots, only: [:show, :edit, :update], param: :code do
    resource  :robot_conditions, only: [:new, :create, :edit, :update, :destroy]
    resources :prize_histories,  only: [:new, :create, :edit, :update, :destroy]
    resources :games, only: [:new, :create, :edit, :update, :destroy], param: :code
  end
  resources :robot_conditions, only: :index
  resources :games, only: :index
  resources :game_details, only: :index
end
