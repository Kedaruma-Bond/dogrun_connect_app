class Admin::UsersController < Admin::BaseController
  before_action :check_grand_admin
  before_action :agreement_set, only: %i[new]
  before_action :user_params, only: %i[create]
  before_action :set_users, :set_q, only: %i[index search]
  before_action :set_user, only: %i[edit update destroy deactivation activation]

  def index; end

  def new
    @user = User.new
    @dogrun_places = DogrunPlace.all
  end

  def create
    @user =  User.new(user_params)
    if @user.save
      UserMailer.admin_user_registration_success(@user).deliver_now
      redirect_to admin_users_path, success: t('.admin_user_create')
      return
    end
    render :new, status: :unprocessable_entity
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, success: t('defaults.destroy_successfully'), status: :see_other }
      format.json { head :no_content }
    end
  end

  def search
    @users_results = @q.result.page(params[:page])
  end

  def deactivation
    @user.update!(deactivation: true)
    respond_to do |format|
      format.html { redirect_to admin_users_path, success: t('.account_frozen') }
      format.json { head :no_content }
    end
  end

  def activation
    @user.update!(deactivation: false)
    respond_to do |format|
      format.html { redirect_to admin_users_path, success: t('.account_activated') }
      format.json { head :no_content }
    end
  end

  private

    def set_users
      @users = User.all.eager_load(:dogs).order(id: :desc).page(params[:page])
    end

    def set_q
      @q = @users.ransack(params[:q])
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :deactivation, :password, :password_confirmation, 
        :role, :dogrun_place_id, :agreement, 
      )
    end

    def agreement_set
      params[:agreement] = true
    end
end
