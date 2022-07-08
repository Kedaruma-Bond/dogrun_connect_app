Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'

  resource :contacts, only: %i[new create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'

  resources :password_resets, only: %i[new create edit update]

  namespace :togo_inu_shitsuke_hiroba do
    get 'top', to: 'static_pages#top'
    get 'compliance_confirmations', to: 'static_pages#compliance_confirmations'
    resources :sessions, only: %i[new create destroy]
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout

    resources :users, only: %i[new create edit update show] do
      resources :dogs, only: %i[index new create update show]
    end
    get 'signup', to: 'users#new', as: :signup

    get 'dog_registration', to: 'dog_registration#new'
    post 'dog_registration', to: 'dog_registration#create'
    post 'dog_registration/confirm', to: 'dog_registration#confirm'

    namespace :admin do
    end
  end
end
