class TogoInuShitsukeHiroba::SessionsController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to(togo_inu_shitsuke_hiroba_top_path, success: t('.login_successfully'))
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
