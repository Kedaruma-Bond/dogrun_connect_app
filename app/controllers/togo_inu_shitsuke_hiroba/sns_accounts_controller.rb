class TogoInuShitsukeHiroba::SnsAccountsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :check_not_guest

  def new
    @sns_account = SnsAccount.new
  end

  def create
    @sns_account = SnsAccount.new(sns_account_params)
    if @sns_account.facebook_id.blank? && @sns_account.instagram_id.blank? && @sns_account.twitter_id.blank?
      redirect_to togo_inu_shitsuke_hiroba_user_path(current_user), notice: t(".cancel_to_registration")
    else
      if SnsAccount.where(user: current_user).present?
        redirect_to togo_inu_shitsuke_hiroba_user_path(current_user), error: t(".registration_duplicated")
      else
        @sns_account.save!
        redirect_to togo_inu_shitsuke_hiroba_user_path(current_user), success: t(".registration_successful")
      end
    end
  end

  def edit
    @sns_account = SnsAccount.find(params[:id])
  end

  def update
    @sns_account = SnsAccount.new(sns_account_params)
    if @sns_account.facebook_id.blank? && @sns_account.instagram_id.blank? && @sns_account.twitter_id.blank?
      redirect_to togo_inu_shitsuke_hiroba_user_path(current_user), notice: t(".cancel_to_registration")
    else
      @sns_account = SnsAccount.find(params[:id])
      @sns_account.update(sns_account_params)
      redirect_to togo_inu_shitsuke_hiroba_user_path(current_user), success: t("defaults.update_successfully")
    end
  end

  def destroy
    @sns_account = SnsAccount.find(params[:id])
    @sns_account.destroy
    redirect_to togo_inu_shitsuke_hiroba_user_path(current_user), success: t("defaults.destroy_successfully")
  end

  private
    def sns_account_params
      params.require(:sns_account).permit(
        :facebook_id, :instagram_id, :twitter_id
      ).merge(user: current_user)
    end
end
