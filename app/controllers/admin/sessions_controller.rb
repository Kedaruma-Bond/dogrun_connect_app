class Admin::SessionsController < Admin::BaseController
  layout 'admin_login'
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :check_admin, only: %i[new create]


  def new; end

  def create
    @user = login(params[:session][:email], params[:session][:password])

    if @user
      redirect_to admin_root_path, success: t('.admin_login')
    else
      flash.now[:error] = t('.login_fail')
      render :new
    end
  end

  def destroy
    logout
    redirect_to '/admin/login', success: t('.logout'), status: :see_other
  end
end
