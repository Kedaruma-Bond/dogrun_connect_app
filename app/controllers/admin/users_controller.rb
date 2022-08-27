class Admin::UsersController < Admin::BaseController
  before_action :check_grand_admin
  before_action :user_params, only: %i[create]
  before_action :set_users, only: %i[index search]
  before_action :set_q, only: %i[index search]
  before_action :set_user, only: %i[edit update destroy deactivation activation]

  def index; end

  def new
    @user = User.new
  end

  def create
    @user =  User.new(user_params)
    if @user.save
      UserMailer.user_registration_success(@user).deliver_now
      redirect_to admin_users_path, success: t('.admin_user_create')
    end
  end

  def edit; end

  def update
    if params[:back]
      redirect_to admin_users_path
      return
    end

    if @dog.valid?
      @dog.update(dog_params)
      redirect_to togo_inu_shitsuke_hiroba_dog_path(@dog.id), success: t('.dog_profile_updated')
      return
    else
      render :edit, status: :unprocessable_entity
    end
    
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_back_or_to admin_users_path, success: t('defaults.destroy_successfully'), status: :see_other }
      format.json { head :no_content }
    end
  end

  def search
    @users_results = @q.result.page(params[:page])
  end

  def deactivation
    @user.update(deactivation: true)
    respond_to do |format|
      format.html ( redirect_back_or_to admin_users_path, success: t('.account_frozen'))
      format.json ( head :no_content )
    end
  end

  def activation
    @user.update(deactivation: false)
    respond_to do |format|
      format.html ( redirect_back_or_to admin_users_path, success: t('.account_activated'))
      format.json ( head :no_content )
    end
  end

  private

    def set_users
      if current_user.name == 'grand_admin'
        @users = User.all.page(params[:page])
      else
        @users = User.where(dogrun_place_id: current_user.dogrun_place_id).page(params[:page])
      end
    end

    def set_q
      @q = @users.ransack(params[:q])
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :deactivation, :enable_notification, :password, :password_confirmation,
        :agreement
      )
    end
end
