class Admin::DogsController < Admin::BaseController
  include Pagy::Backend
  before_action :set_dog, only: %i[show edit update]
  before_action :set_registration_number, only: %i[show update]
  before_action :set_q, only: %i[index search]
  before_action :set_naming_of_registration_number, only: %i[index show update search]
  before_action :set_dogrun_place, :check_grand_admin, only: %i[index search]

  def index
    @pagy, @dogs = pagy(@dogs)
  end

  def show
    return if current_user.grand_admin? || @registration_number.nil?
      
    @registration_number.update!(acknowledge: true)
  end

  def edit
    session[:previous_url] = request.referer 
  end

  def update
    if @dog.update(dog_params)
      respond_to do |format|
        format.html {
          if session[:previous_url].nil?
            redirect_to admin_dogs_path, success: t('defaults.update_successfully')
          else
            redirect_to session[:previous_url], success: t('defaults.update_successfully')
          end
        }
        format.turbo_stream { flash.now[:success] = t('defaults.update_successfully') }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @pagy, @dogs_results = pagy(@q.result(distinct: true))
  end

  private

    def dog_params
      params.require(:dog).permit(
        :thumbnail, :name, :breed, :castration,
        :public, :owner_comment, :sex, :weight, :birthday,
        :mixed_vaccination_certificate, :rabies_vaccination_certificate,
        :license_plate, :date_of_mixed_vaccination, :date_of_rabies_vaccination,
        :registration_prefecture_code, :registration_municipality, :municipal_registration_number
      )
    end

    def set_q
      @dogs = Dog.with_attached_thumbnail.with_attached_rabies_vaccination_certificate.with_attached_mixed_vaccination_certificate.with_attached_license_plate.includes([:user]).order(id: :desc)
      @q = @dogs.ransack(params[:q])
    end
    
    def set_dog
      @dog = Dog.find(params[:id])
    end

    def set_registration_number
      @registration_number = RegistrationNumber.where(dog: @dog).find_by(dogrun_place: current_user.dogrun_place)
    end
end
