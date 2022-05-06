Rails.application.routes.draw do
  namespace :togo_inu_shitsuke_hiroba do
    get 'static_pages/top'
    get 'static_pages/privacy_policy'
    get 'static_pages/terms_of_service'
    get 'static_pages/contact'
    get 'static_pages/compliance_confirmations'
    namespace :admin do

    end
  end
end
