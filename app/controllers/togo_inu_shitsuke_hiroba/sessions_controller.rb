class TogoInuShitsukeHiroba::SessionsController < TogoInuShitsukeHiroba::DogrunPlaceController
  skip_before_action :require_login, only: %i[new create]
  def new; end

  def create
    login(params[:session][:email], params[:session][:password], params[:session][:remember]) do |user, failure|
      if failure
        case failure
        when :invalid_password
          user.register_failed_login!
          flash.now[:error] = t('.login_failed')
        when :locked
          flash.now[:error] = t('.account_locked')
        else
          flash.now[:error] = t('.login_failed')
        end
        render :new
      else
        redirect_back_or_to(togo_inu_shitsuke_hiroba_top_path, success: t('.login_successfully'))
      end
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
