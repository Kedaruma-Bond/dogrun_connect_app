Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  namespace :togo_inu_shitsuke_hiroba do
    get 'static_pages/top'
    get 'static_pages/privacy_policy'
    get 'static_pages/terms_of_service'
    get 'static_pages/compliance_confirmations'

    resources :contacts, only: %i[new create]
    post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
    post 'contacts/back', to: 'contacts#back', as: 'back'

    namespace :admin do
    end
  end
end
