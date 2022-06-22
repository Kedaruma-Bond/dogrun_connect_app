Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'

  resources :contacts, only: %i[new create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'

  namespace :togo_inu_shitsuke_hiroba do
    get 'top', to: 'static_pages#top'
    get 'compliance_confirmations', to: 'static_pages#compliance_confirmations'
    resources :users, only: %i[new create edit update] do
      resources :dogs, shallow: true
    end
    get  'signup', to: 'users#new', as: 'sign_up'
    get  'login', to: 'sessions#new', as: 'login'
    post 'login', to: 'sessions#create'
    post 'logout', to: 'sessions#destroy', as: 'logout'

    namespace :admin do
    end
  end
end
