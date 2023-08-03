class Reon::SessionsController < Reon::DogrunPlaceController
  skip_before_action :require_login, :is_account_deactivated?, only: %i[new create guest_login]
  before_action :remember_checked, only: %i[new]
  
  def new; end

  def create
    login(params[:session][:email], params[:session][:password], params[:session][:remember]) do |user, failure|
      if failure
        case failure
        when :invalid_password
          user.register_failed_login!
          flash.now[:error] = t('local.sessions.login_failed')
        when :locked
          flash.now[:error] = t('local.sessions.account_locked')
        else
          flash.now[:error] = t('local.sessions.login_failed')
        end
        render :new, status: :unprocessable_entity
      else
        redirect_back_or_to(send(@top_path), success: t('local.sessions.login_successfully'))
      end
    end
  end

  def destroy
    logout
    respond_to do |format|
      format.html { redirect_to send(@top_path), notice: t('local.sessions.logout'), status: :see_other }
      format.json { head :no_content }
    end
  end

  def guest_login
    @guest_user = User.create(
      name: 'GUEST',
      email: SecureRandom.alphanumeric(10) + '@example.com',
      password: 'password',
      password_confirmation: 'password',
      deactivation: 'account_activated',
      role: 'guest'
    )
    auto_login(@guest_user)
    redirect_to send(@top_path), success: t('local.sessions.guest_login_successfully')
  end

  def jump_to_signup
    return unless current_user.guest?

    logout
    redirect_to send(@route_selection_path), notice: t('local.sessions.signup_please')
  end

  private
    def remember_checked
      params[:remember] = true
    end

end
