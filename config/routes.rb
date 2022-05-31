Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root to: 'common_pages#top'
  namespace :togo_inu_shitsuke_hiroba do
    get 'top', to: 'static_pages#top'
    get 'privacy_policy', to: 'static_pages#privacy_policy'
    get 'terms_of_service', to:  'static_pages#terms_of_service'
    get 'compliance_confirmations', to: 'static_pages#compliance_confirmations'

    resources :contacts, only: %i[new create]
    post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
    post 'contacts/back', to: 'contacts#back', as: 'back'

    namespace :admin do
    end
  end
end
