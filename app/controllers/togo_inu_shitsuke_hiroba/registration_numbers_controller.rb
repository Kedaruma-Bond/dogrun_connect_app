class TogoInuShitsukeHiroba::RegistrationNumbersController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_registration_number, only: %i[destroy]
  before_action :correct_registration_number_of_dog_owner, only: %i[destroy]

  def destroy
    @registration_number.destroy
    respond_to do |format|
      format.html { redirect_to togo_inu_shitsuke_hiroba_user_path(current_user), success: t('.destroy_successfully'), status: :see_other }
      format.json { header :no_content}
    end
  end

  private
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
