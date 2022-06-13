Rails.application.routes.draw do
  get 'user_sessions/new'
  get 'user_sessions/destroy'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'

  resources :contacts, only: %i[new create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'

  resources :users do
    member do
      get :activate
    end
    resources :dogs, shallow: true
  end

  namespace :togo_inu_shitsuke_hiroba do
    get 'top', to: 'static_pages#top'
    get 'compliance_confirmations', to: 'static_pages#compliance_confirmations'
    resources :signup_form, only: %i[new create]
    post 'signup_form/confirm', to: 'signup_form#confirm', as: 'singup_confirm'

    namespace :admin do
    end
  end
end
