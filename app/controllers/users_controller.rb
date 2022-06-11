class UsersController < ApplicationController
  def activate
    if @user == User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to login_path, notice: t('.success')
    else
      not_authenticated
    end
  end
end
