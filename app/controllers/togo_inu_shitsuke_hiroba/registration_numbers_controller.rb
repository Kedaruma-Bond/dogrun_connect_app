class TogoInuShitsukeHiroba::RegistrationNumbersController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_new_post, only: %i[new]
  before_action :set_dogs, only: %i[new create]
  before_action :set_registration_number, only: %i[destroy]
  before_action :correct_registration_number_of_dog_owner, only: %i[destroy]

  def new
    @registration_number = RegistrationNumber.new
  end

  def create
    @dog = Dog.find_by(id: params[:select_dog])
    if @dog.blank?
      flash.now[:error] = t('local.registration_numbers.select_dog')
      render :new
      return
    end
    
    @registration_number = RegistrationNumber.new(registration_number_params)

    if @registration_number.save
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), success: t('local.registration_numbers.registered_successfully') }
        format.json { header :no_content }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @registration_number.destroy
    respond_to do |format|
      format.html { redirect_to send(@user_path, current_user), success: t('local.registration_numbers.destroy_successfully'), status: :see_other }
      format.json { header :no_content }
    end
  end

  private

    def set_dogs
      @dogs = []
      dogs = Dog.includes(:user).where(user: current_user)
      dogs.each do |dog|
        unless dog.registration_numbers.where(dogrun_place: @dogrun_place).present?
          @dogs << dog
        end
      end
    end

    def registration_number_params
      params.require(:registration_number).permit(
        :registration_number, :agreement
      ).merge(
        dog_id: @dog.id,
        dogrun_place_id: @dogrun_place.id
      )
    end

    def set_registration_number
      @registration_number = RegistrationNumber.find(params[:id])
    end

    def correct_registration_number_of_dog_owner
      dog = Dog.find(@registration_number.dog_id)
      user = User.find(dog.user_id)
      unless correct_user?(user, current_user)
        redirect_to '/', error: t('defaults.require_correct_account')
      end
    end

end
