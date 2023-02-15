class Reon::DogrunPlaceController < ApplicationController
  layout 'reon'
  before_action :set_dogrun_place
  
  private
  
    def set_dogrun_place
      @dogrun_place = DogrunPlace.find(3)
      @top_path = :reon_top_path
      @login_path = :reon_login_path
      @logout_path = :reon_logout_path
      @signup_path = :reon_signup_path
      @guest_login_path = :reon_guest_login_path
      @jump_to_signup_path = :reon_jump_to_signup_path
      @user_path = :reon_user_path
      @edit_user_path = :edit_reon_user_path
      @users_path = :reon_users_path
      @new_user_detail_path = :new_reon_user_detail_path
      @edit_user_detail_path = :edit_reon_user_detail_path
      @user_detail_path = :reon_user_detail_path
      @dog_profile_path = :reon_dog_path
      @edit_dog_path = :edit_reon_dog_path
      @new_registration_number_path = :new_reon_registration_number_path
      @registration_numbers_path = :reon_registration_numbers_path
      @registration_number_path = :reon_registration_number_path 
      @encount_dogs_path = :reon_encount_dogs_path
      @edit_encount_dog_path = :edit_reon_encount_dog_path
      @search_encount_dogs_path = :search_reon_encount_dogs_path
      @entries_path = :reon_entries_path
      @search_entries_path = :search_reon_entries_path
      @pre_entries_path = :reon_pre_entries_path
      @new_sns_account_path = :new_reon_sns_account_path
      @dogrun_name = :reon
      @sns_account_path = :reon_sns_account_path
      @edit_sns_account_path = :edit_reon_sns_account_path
      @dog_registration_path = :reon_dog_registration_path
      @dog_registration_confirm_path = :reon_dog_registration_confirm_path
      @new_article_path = :new_reon_article_path
      @article_path = :reon_article_path
      @new_embed_path = :new_reon_embed_path
      @embed_path = :reon_hiroba_embed_path
      @dogrun_terms_of_service_page = "/reon/terms_of_service"
    end

    def set_dogs_and_registration_numbers_at_local
      return unless logged_in?
      
      @dogs = Dog.with_attached_thumbnail.joins(:registration_numbers).where(registration_numbers: { dogrun_place: @dogrun_place }).where(user_id: current_user.id).order(:id)
      @registration_numbers = @dogs.map do |dog|
        RegistrationNumber.where(dogrun_place: @dogrun_place).find_by(dog_id: dog.id)
      end
    end
    
    def set_staffs
      @staffs = Staff.where(dogrun_place: @dogrun_place).enable
    end

    def check_not_guest
      redirect_to send(@signup_path), error: t('defaults.require_signup') unless !current_user.guest?
    end

end
