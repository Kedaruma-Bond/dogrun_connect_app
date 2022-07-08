class TogoInuShitsukeHiroba::UsersController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  skip_before_action :require_login, only: %i[new create]
  before_action :user_params, only: :create

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.user_registration_success(@user).deliver_now
      login(params[:user][:email], params[:user][:password])
      redirect_to togo_inu_shitsuke_hiroba_dog_registration_path, success: t('.user_create')
      return
    end
    render :new, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :deactivation, :enable_notification, :password, :password_confirmation,
      :agreement
    )
  end
end
