class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  layout 'togo_inu_shitsuke_hiroba'

  def create
    @user = User.find_by_email(params[:email])
    @user.deliver_reset_password_instructions! if @user
    redirect_to(root_path, :notice => 'Instructions have been sent to your email.')
  end

  def edit
  end

  def update
  end
end
