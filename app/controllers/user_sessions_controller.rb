class UserSessionsController < ApplicationController
  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to(, success: t('.login_successfully'))
    else
      flash.now[:alert] = t('.login_failed')
      render :new
    end
  end

  def destroy
    logout
    rediret_to(:top, notice: t('.logout'))
  end
end
