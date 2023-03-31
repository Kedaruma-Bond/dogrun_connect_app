class TogoInuShitsukeHiroba::RegistrationNumbersController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_new_post, only: %i[new]
  before_action :set_dogs, only: %i[new create]
  before_action :set_registration_number, only: %i[destroy]
  before_action :correct_registration_number_of_dog_owner, only: %i[destroy]

  def form_selection
    @confirmation = I18n.t('local.dog_registrations.form_selection.confirmation', registration_card: I18n.t('togo_inu_shitsuke_hiroba.registration_card'))
  end
  
  def have_registration_card
    session[:card_flg] = true
    redirect_to  send(@new_registration_number_path)
  end

  def not_have_registration_card
    session[:card_flg] = false
    redirect_to  send(@new_registration_number_path)
  end

  def new
    @registration_number_hint = I18n.t('local.dog_registrations.new.registration_number_hint', registration_card: I18n.t('togo_inu_shitsuke_hiroba.registration_card'))
    @registration_number = RegistrationNumber.new
  end

  def create
    @dog = Dog.find_by(id: params[:select_dog])
    if !@dog.blank?
      @registration_number = RegistrationNumber.new(registration_number_params)
      if @registration_number.save
        session.delete(:card_flg)
        respond_to do |format|
          format.html { redirect_to send(@user_path, current_user), success: t('local.registration_numbers.registered_successfully') }
          format.json { header :no_content }
        end
      else
        render :new, status: :unprocessable_entity
      end
    else
      respond_to do |format|
        format.html {
          redirect_to send(@new_registration_number_path), error: t('local.registration_numbers.select_dog')
        }
        format.json { header :no_content }
      end
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
