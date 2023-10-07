class Reon::SnsAccountsController < Reon::DogrunPlaceController
  before_action :check_not_guest
  before_action :correct_user_check, only: %i[edit update destroy]

  def new
    @sns_account = SnsAccount.new
  end

  def create
    @sns_account = SnsAccount.new(sns_account_params)
    if SnsAccount.where(user: current_user).present?
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), error: t("local.sns_accounts.registration_duplicated") }
        format.turbo_stream { flash.now[:error] = t("local.sns_accounts.registration_duplicated") }
      end
      return
    end

    if @sns_account.save
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), success: t("local.sns_accounts.registration_successful") }
        format.turbo_stream { flash.now[:success] = t("local.sns_accounts.registration_successful") }
      end
    else
      render :new, status: :unprocessable_entity
    end

  end

  def edit; end

  def update
    if @sns_account.update(sns_account_params)
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), success: t("defaults.update_successfully") }
        format.turbo_stream { flash.now[:success] = t("defaults.update_successfully") }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sns_account.destroy
    respond_to do |format|
      format.html { redirect_to send(@user_path, current_user), success: t("defaults.destroy_successfully"), status: :see_other }
      format.turbo_stream { flash.now[:success] = t("defaults.destroy_successfully") }
    end
  end

  private
    def sns_account_params
      params.require(:sns_account).permit(
        :facebook_id, :instagram_id, :twitter_id
      ).merge(user: current_user)
    end
    
    def correct_user_check
      @sns_account = SnsAccount.find(params[:id])
      redirect_to send(@user_path, current_user), error: t('defaults.not_authorized') unless @sns_account.user == current_user
    end
end
