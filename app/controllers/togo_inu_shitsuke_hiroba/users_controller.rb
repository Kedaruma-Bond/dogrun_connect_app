class TogoInuShitsukeHiroba::UsersController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  skip_before_action :require_login, only: %i[index new create activate update]
  before_action :user_params, only: :confirm

  def index; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    render :new unless @user.save
    case @user.dogrun_place.to_sym
    when :togo_inu_shitsuke_hiroba
      redirect_to 'togo_inu_shitsuke_hiroba/top'
    else
      redirect_to '/', error: t('.error')
    end
  end

  def activate
    if @user == User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to login_path, notice: t('.success')
    else
      not_authenticated
    end
  end

  def update; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :dogrun_place, :deactivation, :enable_notification, :password, :password_confirmation)
  end
end
