Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/about'

  resources :campuses, only: [:index, :show]
  resources :contests, only: [:index, :show]

end
