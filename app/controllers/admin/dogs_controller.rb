class Admin::DogsController < Admin::BaseController
  before_action :set_dogs, only: %i[index search]
  before_action :set_dog, only: %i[show edit update]
  before_action :dog_params, only: %i[update]
  before_action :set_q, only: %i[index search]

  def index; end

  def show
    if current_user.name != "grand_admin"
      @registration_number = RegistrationNumber.where(dog: @dog).find_by(dogrun_place: current_user.dogrun_place)
    end
  end

  def edit; end

  def update
    if @dog.valid?
      @dog.update(dog_params)
      redirect_to admin_dogs_path, success: t('defaults.update_successfully')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @dogs_results = @q.result.page(params[:page])
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

    def set_dogs
      case current_user.name
      when "grand_admin"
        @dogs = Dog.with_attached_thumbnail.with_attached_rabies_vaccination_certificate.with_attached_mixed_vaccination_certificate.includes([:user]).order(updated_at: :desc).page(params[:page])
      else
        @dogs = Dog.dogrun_place_id(current_user.dogrun_place_id).with_attached_thumbnail.with_attached_rabies_vaccination_certificate.with_attached_mixed_vaccination_certificate.order(updated_at: :desc).page(params[:page])
      end
    end

    def set_dog
      @dog = Dog.find(params[:id])
    end

    def set_q
      @q = @dogs.ransack(params[:q])
    end

end
