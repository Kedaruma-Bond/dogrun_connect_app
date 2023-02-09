class Reon::RegistrationNumbersController < Reon::DogrunPlaceController
  before_action :set_registration_number, only: %i[destroy]
  before_action :correct_registration_number_of_dog_owner, only: %i[destroy]

  def new
    @registration_number = RegistrationNumber.new
    @dogs = []
    dogs = Dog.includes(:user).where(user: current_user)
    dogs.each do |dog|
      unless dog.registration_numbers.where(dogrun_place: @dogrun_place).present?
        @dogs << dog
      end
    end
  end

  def create
    select_dogs_allocation(params[:select_dog])
    num = 0
    while num <= @select_dogs_values.count - 1
      
      case @select_dogs_values[num]
      when '1'
        @dog = @dogs[num]
        return
      when '0'
        num += 1
      end
    end
    if @dog.blank?
      respond_to do |format|
        format.html { render :new, flash.now[:error] = t('local.registration_numbers.select_dog') }
      end
      return
    end
    @registration_number = RegistrationNumber.new(registration_number_params)
    if @registration_number.save
      respond_to do |format|
        format.html { redirect_to send(user_path, current_user), success: t('local.registration_numbers.registered_successfully') }
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
      format.json { header :no_content}
    end
  end

  private

    def registration_number_params
      
    end

    def set_registration_number
      @registration_number = RegistrationNumber.find(params[:id])
    end

    def correct_registration_number_of_dog_owner
      dog = Dog.find(@registration_number.dog_id)
      user = User.find(dog.user_id)
      unless correct_user?(user)
        redirect_to '/', error: t('defaults.require_correct_account')
      end
    end

end
