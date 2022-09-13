class ApplicationController < ActionController::Base
  include EntryHelper
  include SessionHelper
  include EntryConcern
  include PostConcern
  before_action :require_login
  add_flash_types :success, :notice, :error
  protect_from_forgery with: :exception

  def not_authenticated
    redirect_to '/', error: t('defaults.require_login')
  end

  private
  
    def set_dogs
      return unless logged_in?
      
      @dogs = Dog.where(user_id: current_user.id)
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

  helper_method :correct_dog_owner
  helper_method :correct_user
end
