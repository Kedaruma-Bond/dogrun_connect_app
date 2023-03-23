class Admin::RegistrationNumbersController < Admin::BaseController
  before_action :set_registration_number, only: %i[update]
  before_action :correct_admin_check, only: %i[update]

  def update
    if @registration_number.update(registration_number_params)
      @update_success_flg = true
      respond_to do |format|
        format.html { 
          if request.referer.nil?
            redirect_to admin_dogs_path, success: t('.registration_number_updated_successfully') 
          else
            redirect_to request.referer, success: t('.registration_number_updated_successfully') 
          end
        }
        format.turbo_stream { flash.now[:success] = t('.registration_number_updated_successfully') }
      end
    else
      @update_success_flg = false 
      respond_to do |format|
        format.html { 
          if request.referer.nil?
            redirect_to admin_dogs_path, error: t('.registration_number_updated_error') 
          else
            redirect_to request.referer, error: t('.registration_number_updated_error') 
          end
        }
        format.turbo_stream { flash.now[:error] = t('.registration_number_updated_error') }
      end
    end
  end

  private
    def registration_number_params
      params.require(:registration_number).permit(
        :registration_number
      )
    end

    def set_registration_number
      @registration_number = RegistrationNumber.find(params[:id])
    end

    def correct_admin_check
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin? ||  @registration_number.dogrun_place == current_user.dogrun_place
    end
end
