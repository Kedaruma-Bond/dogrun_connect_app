class TogoInuShitsukeHiroba::UserDetailsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_new_post, only: %i[new edit]
  before_action :check_not_guest

  def new
    @user_detail = UserDetail.new
  end

  def signup_fully_route
    @user_detail = UserDetail.new
  end

  def create
    @user_detail = UserDetail.new(user_detail_params)
    case session[:fully_flg]
    when true
      if @user_detail.save
        if @dogrun_place.registration_card.blank?
          redirect_to send(@fully_not_have_registration_card_path), success: t('local.user_details.fully_route_created_successfully')
        else
          redirect_to send(@fully_form_selection_path), success: t('local.user_details.fully_route_created_successfully')
        end
      else
        render :signup_fully_route, status: :unprocessable_entity
      end
    else
      if @user_detail.save
        respond_to do |format|
          format.html { redirect_to send(@user_path, current_user), success: t('local.user_details.created_successfully') }
          format.turbo_stream { flash.now[:success] = t('local.user_details.created_successfully') }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @user_detail = UserDetail.find(params[:id])
  end

  def update
    @user_detail = UserDetail.find(params[:id])
    if @user_detail.update(user_detail_params)
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), notice: t("defaults.update_successfully") }
        format.turbo_stream { flash.now[:success] = t("defaults.update_successfully") }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_detail = UserDetail.find(params[:id])
    @user_detail.destroy
    respond_to do |format|
      format.html { redirect_to send(@user_path, current_user), success: t("defaults.destroy_sucessfully"), status: :see_other }
      format.turbo_stream { flash.now[:success] = t("defaults.destroy_successfully") }
    end
  end

  private
    def user_detail_params
      params.require(:user_detail).permit(
        :zip_code, :address_1, :address_2, :phone_number
      ).merge(user_id: current_user.id)
    end
end
