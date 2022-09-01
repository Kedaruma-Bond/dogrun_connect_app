class TogoInuShitsukeHiroba::SessionsController < TogoInuShitsukeHiroba::DogrunPlaceController
  skip_before_action :require_login, only: %i[new create guest_login]
  before_action :remember_checked, only: %i[new]
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

  def guest_login
    @guest_user = User.create(
      name: 'ゲスト',
      email: SecureRandom.alphanumeric(10) + '@example.com',
      password: 'password',
      password_confirmation: 'password',
      deactivation: 'account_activated',
      role: 'guest'
    )
    auto_login(@guest_user)
    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.guest_login_successfully')
  end

  private
    def remember_checked
      params[:rememer] = true
    end

end
