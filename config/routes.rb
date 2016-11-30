Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/about'

  resources :campusess, only: [:index, :show]
  resources :contests,  only: [:index, :show]

end
