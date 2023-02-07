class Admin::RegistrationNumbersController < Admin::BaseController
  
  def update
    @registration_number = RegistrationNumber.find(params[:id])
    if @registration_number.update(registration_number_params)
      @update_success_flg = true
      respond_to do |format|
        format.html { redirect_to request.referer, success: t('.registration_number_updated_successfully') }
        format.turbo_stream { flash.now[:success] = t('.registration_number_updated_successfully') }
      end
    else
      @update_success_flg = false 
      respond_to do |format|
        format.html { redirect_to request.referer, error: t('.registration_number_updated_error') }
        format.turbo_stream { flash.now[:error] = t('.registration_number_updated_error') }
      end
    end
  end

  private
    def registration_number_params
      params.permit(
        :registration_number
      )
    end
end
