class TogoInuShitsukeHiroba::DogrunPlaceController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  before_action :set_dogrun_place
  
  private
  
    def set_dogrun_place
      @dogrun_place = DogrunPlace.find(2)
      @top_path = :togo_inu_shitsuke_hiroba_top_path
      @login_path = :togo_inu_shitsuke_hiroba_login_path
      @logout_path = :togo_inu_shitsuke_hiroba_logout_path
      @signup_path = :togo_inu_shitsuke_hiroba_signup_path
      @guest_login_path = :togo_inu_shitsuke_hiroba_guest_login_path
      @jump_to_signup_path = :togo_inu_shitsuke_hiroba_jump_to_signup_path
      @user_path = :togo_inu_shitsuke_hiroba_user_path
      @users_path = :togo_inu_shitsuke_hiroba_users_path
      @dog_profile_path = :togo_inu_shitsuke_hiroba_dog_path
      @registration_number_path = :togo_inu_shitsuke_hiroba_registration_number_path 
      @encount_dogs_path = :togo_inu_shitsuke_hiroba_encount_dogs_path
      @edit_encount_dog_path = :edit_togo_inu_shitsuke_hiroba_encount_dog_path
      @entries_path = :togo_inu_shitsuke_hiroba_entries_path
      @pre_entries_path = :togo_inu_shitsuke_hiroba_pre_entries_path
      @new_sns_account_path = :new_togo_inu_shitsuke_hiroba_sns_account_path
      @sns_account_path = :togo_inu_shitsuke_hiroba_sns_account_path
      @edit_sns_account_path = :edit_togo_inu_shitsuke_hiroba_sns_account_path
      @dog_registration_path = :togo_inu_shitsuke_hiroba_dog_registration_path
      @dog_registration_confirm_path = :togo_inu_shitsuke_hiroba_dog_registration_confirm_path
    end

    def set_dogs_and_registration_numbers_at_local
      return unless logged_in?
      
      @dogs = Dog.with_attached_thumbnail.joins(:registration_numbers).where(registration_numbers: { dogrun_place: @dogrun_place }).where(user_id: current_user.id).order(:id)
      @registration_numbers = @dogs.map do |dog|
        RegistrationNumber.find_by(dog_id: dog.id)
      end
    end
    
    def set_staffs
      @staffs = Staff.where(dogrun_place: @dogrun_place).enable
    end

    def check_not_guest
      redirect_to togo_inu_shitsuke_hiroba_signup_path, error: t('defaults.require_signup') unless !current_user.guest?
    end

end
