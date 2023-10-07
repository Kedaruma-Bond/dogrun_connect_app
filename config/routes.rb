Rails.application.routes.draw do
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  
  resources :attachments, only: :index

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'sitemap', to: redirect("https://s3-ap-northeast-1.amazonaws.com/#{Rails.application.credentials.aws[:s3_bucket_name]}/sitemaps/sitemap.xml.gz")
  
  resource :contacts, only: %i[new create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  
  resources :password_resets, only: %i[new create edit update]
  
  namespace :togo_inu_shitsuke_hiroba do
    get 'top', to: 'static_pages#top'
    get 'top_contents', to: 'static_pages#top_contents'
    resource :session, only: %i[new create destroy]
    post '/guest_login', to: 'sessions#guest_login'
    post '/jump_to_signup', to: 'sessions#jump_to_signup'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout

    resources :sns_accounts, only: %i[new create edit update destroy]
    resources :encount_dogs, only: %i[index edit update destroy] do
      collection do
        get 'search', to: 'encount_dogs#search'
      end
    end

    resource :pre_entry, only: %i[destroy]
    resources :entries, only: %i[index create destroy] do
      collection do
        get 'search', to: 'entries#search'
      end
    end
    resource :entry, only: %i[update]
    resources :users, only: %i[new create show]
    get 'route_selection', to: 'users#route_selection'
    get 'fully_route', to: 'users#fully_route'
    get 'minimum_route', to: 'users#minimum_route'
    resources :user_details, only: %i[new create show edit update destroy] do
      collection do
        get 'signup_fully_route', to: 'user_details#signup_fully_route'
      end
    end
    resources :dogs, only: %i[show edit update]
    resources :registration_numbers, only: %i[new create destroy] do
      member do
        get 'entries_record_analysis', to: 'registration_numbers#entries_record_analysis'
      end
    end
    get 'registration_numbers/form_selection', to: 'registration_numbers#form_selection'
    get 'registration_numbers/have_registration_card', to: 'registration_numbers#have_registration_card'
    get 'registration_numbers/not_have_registration_card', to: 'registration_numbers#not_have_registration_card' 
    
    get 'signup', to: 'users#new', as: :signup
    
    get 'article_post', to: 'article_post#new'
    post 'article_post', to: 'article_post#create'

    get 'dog_fully_registration/form_selection', to: 'dog_fully_registration#form_selection'
    get 'dog_fully_registration/have_registration_card', to: 'dog_fully_registration#have_registration_card'
    get 'dog_fully_registration/not_have_registration_card', to: 'dog_fully_registration#not_have_registration_card'
    get 'dog_fully_registration', to: 'dog_fully_registration#new'
    post 'dog_fully_registration', to: 'dog_fully_registration#create'
    
    get 'dog_registration/form_selection', to: 'dog_registration#form_selection'
    get 'dog_registration/have_registration_card', to: 'dog_registration#have_registration_card'
    get 'dog_registration/not_have_registration_card', to: 'dog_registration#not_have_registration_card'
    get 'dog_registration', to: 'dog_registration#new'
    post 'dog_registration', to: 'dog_registration#create'
  end
  
  namespace :reon do
    get 'top', to: 'static_pages#top'
    get 'top_contents', to: 'static_pages#top_contents'
    resource :session, only: %i[new create destroy]
    post '/guest_login', to: 'sessions#guest_login'
    post '/jump_to_signup', to: 'sessions#jump_to_signup'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout

    resources :sns_accounts, only: %i[new create edit update destroy]
    resources :encount_dogs, only: %i[index edit update destroy] do
      collection do
        get 'search', to: 'encount_dogs#search'
      end
    end

    resource :pre_entry, only: %i[destroy]
    resources :entries, only: %i[index create destroy] do
      collection do
        get 'search', to: 'entries#search'
      end
    end
    resource :entry, only: %i[update]
    resources :users, only: %i[new create show]
    get 'route_selection', to: 'users#route_selection'
    get 'fully_route', to: 'users#fully_route'
    get 'minimum_route', to: 'users#minimum_route'
    resources :user_details, only: %i[new create show edit update destroy] do
      collection do
        get 'signup_fully_route', to: 'user_details#signup_fully_route'
      end
    end
    resources :dogs, only: %i[show edit update]
    resources :registration_numbers, only: %i[new create destroy] do
      member do
        get 'entries_record_analysis', to: 'registration_numbers#entries_record_analysis'
      end
    end
    get 'registration_numbers/form_selection', to: 'registration_numbers#form_selection'
    get 'registration_numbers/have_registration_card', to: 'registration_numbers#have_registration_card'
    get 'registration_numbers/not_have_registration_card', to: 'registration_numbers#not_have_registration_card' 
    
    get 'signup', to: 'users#new', as: :signup

    get 'article_post', to: 'article_post#new'
    post 'article_post', to: 'article_post#create'

    get 'dog_fully_registration/form_selection', to: 'dog_fully_registration#form_selection'
    get 'dog_fully_registration/have_registration_card', to: 'dog_fully_registration#have_registration_card'
    get 'dog_fully_registration/not_have_registration_card', to: 'dog_fully_registration#not_have_registration_card'
    get 'dog_fully_registration', to: 'dog_fully_registration#new'
    post 'dog_fully_registration', to: 'dog_fully_registration#create'

    get 'dog_registration/form_selection', to: 'dog_registration#form_selection'
    get 'dog_registration/have_registration_card', to: 'dog_registration#have_registration_card'
    get 'dog_registration/not_have_registration_card', to: 'dog_registration#not_have_registration_card' 
    get 'dog_registration', to: 'dog_registration#new'
    post 'dog_registration', to: 'dog_registration#create'
  end

  namespace :admin do
    root 'dashboards#index'
    get 'grand_admin_index', to: 'dashboards#grand_admin_index', as: :grand_admin_index
    get 'entries_count', to: 'dashboards#entries_count', as: :entries_count
    get 'entries_ranking', to: 'dashboards#entries_ranking', as: :entries_ranking

    resources :dogrun_places, only: %i[index new create edit update show] do
      member do
        patch 'force_closed', to: 'dogrun_places#force_closed'
        patch 'release', to: 'dogrun_places#release'
      end
    end

    resources :posts, only: %i[index create destroy] do
      collection do
        get 'search', to: 'posts#search'
        get 'dogrun_board', to: 'posts#dogrun_board'
      end
      member do
        get 'set_publish_limit', to: 'posts#set_publish_limit'
        patch 'start_to_publish', to: 'posts#start_to_publish'
        patch 'cancel_to_publish', to: 'posts#cancel_to_publish'
        resource :article, only: %i[new create edit update]
        resource :embed, only: %i[new create edit update]
      end
    end
    
    resources :staffs, only: %i[index new create destroy] do
      member do
        patch 'enable_notification', to: 'staffs#enable_notification'
        patch 'disable_notification', to: 'staffs#disable_notification'
      end
    end

    resources :dogs, only: %i[index show edit update] do
      collection do
        get 'search', to: 'dogs#search'
      end
    end

    resources :registration_numbers, only: %i[index edit update] do
      collection do
        get 'search', to: 'registration_numbers#search'
      end
    end

    resources :sns_accounts, only: %i[new create edit update destroy]

    resources :users, only: %i[index new create destroy] do
      collection do
        get 'search', to: 'users#search'
      end
      member do
        patch 'deactivation', to: 'users#deactivation'
        patch 'activation', to: 'users#activation'
      end
    end

    resources :entries, only: %i[index create update destroy] do
      collection do
        get 'search', to: 'entries#search'
      end
      member do
        get 'exit_command_selector', to: 'entries#exit_command_selector'
      end
    end
    
    resource :session, only: %i[new create destroy]
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end
end
