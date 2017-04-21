Rails.application.routes.draw do

  get 'games/show'

  root 'static_pages#home'

  resources :campuses, only: [:index, :show], param: :code
  resources :contests, only: [:index, :show], param: :nth
  resources :contest_entries, only: [:index]
  resources :robots, only: [:show], param: :code
  resources :games, only: [:show], param: :code

end
