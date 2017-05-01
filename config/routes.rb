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
  resources :contest_entries, only: [:index]
  resources :robots, only: [:show, :edit, :update], param: :code
  resources :games, only: [:show], param: :code
  resources :robot_conditions, only: [:edit, :update], param: :code
end
