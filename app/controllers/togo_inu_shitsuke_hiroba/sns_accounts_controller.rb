class TogoInuShitsukeHiroba::SnsAccountsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :check_not_guest

  def new
    @sns_account = SnsAccount.new
  end

  def create
    @sns_account = SnsAccount.new(sns_account_params)
    if @sns_account.facebook_id.blank? && @sns_account.instagram_id.blank? && @sns_account.twitter_id.blank?
      @create_cancel_flag = true
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), notice: t("local.sns_accounts.cancel_to_registration") }
        format.turbo_stream { flash.now[:notice] = t("local.sns_accounts.cancel_to_registration") }
      end
    else
      if SnsAccount.where(user: current_user).present?
        respond_to do |format|
          format.html { redirect_to send(@user_path, current_user), error: t("local.sns_accounts.registration_duplicated") }
          format.turbo_stream { flash.now[:error] = t("local.sns_accounts.registration_duplicated") }
        end
      else
        @sns_account.save!
        respond_to do |format|
          format.html { redirect_to send(@user_path, current_user), success: t("local.sns_accounts.registration_successful") }
          format.turbo_stream { flash.now[:success] = t("local.sns_accounts.registration_successful") }
        end
      end
    end
  end

  def edit
    @sns_account = SnsAccount.find(params[:id])
  end

  def update
    @sns_account = SnsAccount.find(params[:id])
    sns_account = SnsAccount.new(sns_account_params)
    if sns_account.facebook_id.blank? && sns_account.instagram_id.blank? && sns_account.twitter_id.blank?
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), notice: t("local.sns_accounts.cancel_to_edit") }
        format.turbo_stream { flash.now[:notice] = t("local.sns_accounts.cancel_to_edit") }
      end
    else
      @correct_update_flag = true
      @sns_account.update(sns_account_params)
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), success: t("defaults.update_successfully") }
        format.turbo_stream { flash.now[:success] = t("defaults.update_successfully") }
      end
    end
  end

  def destroy
    @sns_account = SnsAccount.find(params[:id])
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
end
