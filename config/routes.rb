Rails.application.routes.draw do
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'

  resources :contacts, only: %i[new create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'

  resources :password_resets, only: %i[new create edit update]

  namespace :togo_inu_shitsuke_hiroba do
    get 'top', to: 'static_pages#top'
    get 'compliance_confirmations', to: 'static_pages#compliance_confirmations'
    resources :users, only: %i[new create edit show update edit update] do
      resource :dogs
    end
    get 'signup', to: 'users#new', as: :signup
    resources :sessions, only: %i[new create destroy]
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout

    namespace :admin do
    end
  end
end

# == Route Map
#
