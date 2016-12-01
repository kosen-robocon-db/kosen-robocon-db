Rails.application.routes.draw do
  root 'static_pages#home'

  resources :campuses, only: [:index, :show]
  resources :contests, only: [:index, :show]

end
