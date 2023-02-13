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
  before_action :require_login
  add_flash_types :success, :notice, :error
  protect_from_forgery with: :exception
  include Dry::Effects::Handler.Reader(:current_user)

  around_action :set_current_user

  def not_authenticated
    redirect_to '/', error: t('defaults.require_login')
  end

  private
    def set_current_user
      with_current_user(current_user) { yield }
    end

    def get_fb_appId
      gon.fb_appId = Rails.application.credentials.meta_tags[:facebook_id]
    end
    
    def correct_dog_owner
      dog = Dog.find(params[:id])
      @user = User.find(dog.user_id)
      unless correct_user?(@user)
        redirect_to '/', error: t('defaults.require_correct_account')
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless correct_user?(@user)
        redirect_to '/', error: t('defaults.require_correct_account')
      end
    end

end
