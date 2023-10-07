class Admin::RegistrationNumbersController < Admin::BaseController
  include Pagy::Backend
  before_action :set_q, only: %i[index search]
  before_action :set_registration_number, only: %i[edit update]
  before_action :set_naming_of_registration_number, only: %i[index search]
  before_action :correct_admin_check, only: %i[update]
  before_action :set_dogrun_place, only: %i[index search]

  def index
    @pagy, @registration_numbers = pagy(@registration_numbers)
  end

  def edit; end

  def update
    if @registration_number.update(registration_number_params)
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

  def search
    @pagy, @registration_numbers_results = pagy(@q.result(distinct: true))
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

    def set_q
      @registration_numbers = RegistrationNumber.dogrun_place_id(current_user.dogrun_place_id).order(created_at: :desc)
      @q = @registration_numbers.ransack(params[:q])
    end

    def correct_admin_check
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin? ||  @registration_number.dogrun_place == current_user.dogrun_place
    end
end
