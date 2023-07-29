class ApplicationController < ActionController::Base
  include EntryHelper
  include SessionHelper
  include DogHelper
  include RegistrationNumberHelper
  include UserHelper
  include ArticleHelper
  include EncountDogHelper
  include DogrunPlaceHelper
  include StaffHelper
  include EntryConcern
  before_action :require_login, :is_account_deactivated?
  add_flash_types :success, :notice, :error
  protect_from_forgery with: :exception

  private

    def is_account_deactivated?
      if current_user.active_for_authentication?
        return
      else
        logout
        redirect_to root_path, error: t('defaults.request_denied')
      end
    end
    
    def not_authenticated
      redirect_to '/', error: t('defaults.require_login')
    end
    
    def get_fb_appId
      gon.fb_appId = Rails.application.credentials.meta_tags[:facebook_id]
    end
    
    def correct_dog_owner
      dog = Dog.find(params[:id])
      @user = User.find(dog.user_id)
      unless correct_user?(@user, current_user)
        redirect_to '/', error: t('defaults.require_correct_account')
      end
    end
    
    # users#showのアカウントチェックで適用してる
    def correct_user
      @user = User.find(params[:id])
      unless correct_user?(@user, current_user)
        redirect_to '/', error: t('defaults.require_correct_account')
      end
    end

    def set_new_post
      @post = Post.new
    end

end
