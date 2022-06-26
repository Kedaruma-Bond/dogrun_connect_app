class TogoInuShitsukeHiroba::SessionsController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && login(params[:session][:email], params[:session][:password])
      redirect_back_or_to(togo_inu_shitsuke_hiroba_top_path, success: t('.login_successfully'))
    else
      flash.now[:error] = t('.login_failed')
      render :new
    end
  end

  def destroy
    logout
    respond_to do |format|
      format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, notice: t('.logout'), status: :see_other }
      format.json { head :no_content }
    end
  end
end
