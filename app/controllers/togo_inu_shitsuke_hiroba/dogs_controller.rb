class TogoInuShitsukeHiroba::DogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_dog_and_registration_number, only: %i[show edit update] 
  before_action :correct_dog_owner, only: %i[edit update]
  before_action :dog_params, only: %i[update]

  def show
    @user = User.find(@dog.user_id)
    @entries = Entry.where(dog: @dog).where(registration_number_id: @registration_number.id).joins(:registration_number).where(registration_number: { dogrun_place: @dogrun_place } ).sort.reverse
    @Num_of_entry_records_to_display = 5
    @Num_of_entry_records_to_display.freeze
    @encount_dog = EncountDog.where(user_id: current_user.id).find_by(dog_id: @dog)
  end

  def edit; end

  def update
    if @dog.update(dog_params)
      redirect_to togo_inu_shitsuke_hiroba_dog_path(@dog.id), success: t('.dog_profile_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_dog_and_registration_number
    @dog = Dog.find(params[:id])
    @registration_number = RegistrationNumber.where(dog_id: @dog.id).find_by(dogrun_place: @dogrun_place)
  end
  
  def dog_params
    params.require(:dog).permit(
      :name, :birthday, :breed, :castration, :public,
      :owner_comment, :sex, :weight, :filming_approval, :sns_post_approval,
      :thumbnail, :mixed_vaccination_certificate, :rabies_vaccination_certificate, :license_plate,
      :date_of_mixed_vaccination, :date_of_rabies_vaccination, :registration_prefecture_code,
      :registration_municipality, :municipal_registration_number
    ).merge(user_id: current_user.id)
  end
end
