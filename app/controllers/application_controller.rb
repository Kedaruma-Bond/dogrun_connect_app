class ApplicationController < ActionController::Base
  include EntryHelper
  include SessionHelper
  include DogHelper
  include EntryConcern
  before_action :require_login
  add_flash_types :success, :notice, :error
  protect_from_forgery with: :exception

  def not_authenticated
    redirect_to '/', error: t('defaults.require_login')
  end

  private
    
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
