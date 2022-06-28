class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  def create
    @user = User.find_by(email: params[:email])

    @user&.deliver_reset_password_instructions!

    redirect_to(root_path, notice: t('.instruction'))
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    return if @user.present?

    not_authenticated
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    # the next line makes the password confirmation validation work
    @user.password_confirmation = params[:user][:password_confirmation]
    # the next line clears the temporary token and updates the password
    if @user.change_password(params[:user][:password])
      redirect_to(root_path, success: t('.success'))
    else
      render action: :edit
    end
  end
end
