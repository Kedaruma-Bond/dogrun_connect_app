class Admin::SnsAccountsController < Admin::BaseController
  before_action :sns_account_params, only: %i[create update]

  def new
    @sns_account = SnsAccount.new
  end

  def create
    @sns_account = SnsAccount.new(sns_account_params)
    if @sns_account.facebook_id.blank? && @sns_account.instagram_id.blank? && @sns_account.twitter_id.blank?
      redirect_to  admin_dogrun_place_path(current_user.dogrun_place), notice: t(".cancel_to_registration")
    else
      @sns_account.save
      redirect_to admin_dogrun_place_path(current_user.dogrun_place), success: t(".registration_successful")
    end
  end

  def edit
    @sns_account = SnsAccount.find(params[:id])
  end

  def update
    @sns_account = SnsAccount.new(sns_account_params)
    if @sns_account.facebook_id.blank? && @sns_account.instagram_id.blank? && @sns_account.twitter_id.blank?
      redirect_to  admin_dogrun_place_path(current_user.dogrun_place), notice: t(".cancel_to_update")
    else
      @sns_account = SnsAccount.find(params[:id])
      @sns_account.update(sns_account_params)
      redirect_to admin_dogrun_place_path(current_user.dogrun_place), success: t("defaults.update_successfully")
    end
  end

  def destroy
    @sns_account = SnsAccount.find(params[:id])
    @sns_account.destroy
    redirect_to admin_dogrun_place_path(current_user.dogrun_place), success: t("defaults.destroy_successfully")
  end

  private
    def sns_account_params
      params.require(:sns_account).permit(
        :facebook_id, :instagram_id, :twitter_id
      ).merge(dogrun_place: current_user.dogrun_place)
    end
end
