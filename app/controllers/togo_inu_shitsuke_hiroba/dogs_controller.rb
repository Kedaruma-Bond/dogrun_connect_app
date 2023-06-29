class TogoInuShitsukeHiroba::DogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_new_post, only: %i[show edit]
  before_action :set_dog_and_registration_number, only: %i[show edit update] 
  before_action :correct_dog_owner, only: %i[edit update]

  def show
    session[:previous_path] = request.referer unless previous_action_was_edit?

    @user = User.find(@dog.user_id)
    if !@registration_number.nil?
      @entries = Entry.where(dog: @dog).where(registration_number_id: @registration_number.id).joins(:registration_number).where(registration_number: { dogrun_place: @dogrun_place } ).sort.reverse
    end
    @encount_dog = EncountDog.where(user_id: current_user.id).find_by(dog_id: @dog)
    @num_of_entry_records_to_display = 5
    
    # x 個以上重複したencount recordを削除
    if current_user == @user
      dogs = Dog.includes(:registration_numbers).where(user: current_user).where(registration_numbers: { dogrun_place: @dogrun_place } )
      recent_entry_ids = []
      # 直近 x 件のentryのIDを取得
      dogs.each do |dog|
        recent_entry_ids << Entry.includes(:dog, :registration_number).where(dog: dog).where(registration_numbers: { dogrun_place_id: @dogrun_place.id } ).order(entry_at: :desc).first(@num_of_entry_records_to_display).pluck(:id)
      end
      
      # 直近 x 件以外のentryが関連付けられたencountデータを削除
      encounts = Encount.where(user_id: current_user.id).where(dogrun_place_id: @dogrun_place.id)
      encounts.where.not(entry_id: recent_entry_ids.flatten).destroy_all
    end
  end

  def edit; end

  def update
    if @dog.update(dog_params)
      redirect_to send(@dog_profile_path, @dog.id), success: t('local.dogs.dog_profile_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def previous_action_was_edit?
      request.referer&.include?("edit")
    end

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
