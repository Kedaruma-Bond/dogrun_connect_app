class Admin::SnsAccountsController < Admin::BaseController

  def new
    @sns_account = SnsAccount.new
  end

  def create
    @sns_account = SnsAccount.new(sns_account_params)
    if @sns_account.facebook_id.blank? && @sns_account.instagram_id.blank? && @sns_account.twitter_id.blank?
      @create_cancel_flag = true
      respond_to do |format|
        format.html { redirect_to  admin_dogrun_place_path(current_user.dogrun_place), notice: t(".cancel_to_registration") }
        format.turbo_stream { flash.now[:notice] = t(".cancel_to_registration") }
      end
    else
      if SnsAccount.where(dogrun_place: current_user.dogrun_place).present?
        respond_to do |format|
          format.html { redirect_to admin_dogrun_place_path(current_user.dogrun_place), error: t(".registration_duplicated") }
          format.turbo_stream { flash.now[:error] = t(".registration_duplicated") }
        end
      else
        @sns_account.save!
        respond_to do |format|
          format.html { redirect_to admin_dogrun_place_path(current_user.dogrun_place), success: t(".registration_successful") }
          format.turbo_stream { flash.now[:success] = t(".registration_successful") }
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
        format.html { redirect_to admin_dogrun_place_path(current_user.dogrun_place), notice: t(".cancel_to_update") }
        format.turbo_stream {flash.now[:notice] =  t(".cancel_to_update") }
      end
    else
      @correct_update_flag = true
      @sns_account.update(sns_account_params)
      respond_to do |format|
        format.html { redirect_to admin_dogrun_place_path(current_user.dogrun_place), success: t("defaults.update_successfully") }
        format.turbo_stream { flash.now[:success] = t("defaults.update_successfully") }
      end
    end
  end

  def destroy
    @dogrun_place = current_user.dogrun_place
    @sns_account = SnsAccount.find(params[:id])
    @sns_account.destroy
    respond_to do |format|
      format.html { redirect_to admin_dogrun_place_path(current_user.dogrun_place), success: t("defaults.destroy_successfully"), status: :see_other }
      format.turbo_stream { flash.now[:success] = t("defaults.destroy_successfully") }
    end
  end

  private
    def sns_account_params
      params.require(:sns_account).permit(
        :facebook_id, :instagram_id, :twitter_id
      ).merge(dogrun_place: current_user.dogrun_place)
    end
end
