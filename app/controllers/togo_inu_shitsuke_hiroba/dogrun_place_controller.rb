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
      @edit_user_path = :edit_togo_inu_shitsuke_hiroba_user_path
      @users_path = :togo_inu_shitsuke_hiroba_users_path
      @new_user_detail_path = :new_togo_inu_shitsuke_hiroba_user_detail_path
      @edit_user_detail_path = :edit_togo_inu_shitsuke_hiroba_user_detail_path
      @new_user_detail_path = :new_togo_inu_shitsuke_hiroba_user_detail_path
      @user_detail_path = :togo_inu_shitsuke_hiroba_user_detail_path
      @dog_profile_path = :togo_inu_shitsuke_hiroba_dog_path
      @edit_dog_path = :edit_togo_inu_shitsuke_hiroba_dog_path
      @new_registration_number_path = :new_togo_inu_shitsuke_hiroba_registration_number_path
      @registration_numbers_path = :togo_inu_shitsuke_hiroba_registration_numbers_path
      @registration_number_path = :togo_inu_shitsuke_hiroba_registration_number_path 
      @rns_form_selection_path = :togo_inu_shitsuke_hiroba_registration_numbers_form_selection_path
      @rns_have_registration_card_path = :togo_inu_shitsuke_hiroba_registration_numbers_have_registration_card_path
      @rns_not_have_registration_card_path = :togo_inu_shitsuke_hiroba_registration_numbers_not_have_registration_card_path
      @encount_dog_path = :togo_inu_shitsuke_hiroba_encount_dog_path
      @encount_dogs_path = :togo_inu_shitsuke_hiroba_encount_dogs_path
      @edit_encount_dog_path = :edit_togo_inu_shitsuke_hiroba_encount_dog_path
      @search_encount_dogs_path = :search_togo_inu_shitsuke_hiroba_encount_dogs_path
      @entry_path = :togo_inu_shitsuke_hiroba_entry_path
      @entries_path = :togo_inu_shitsuke_hiroba_entries_path
      @search_entries_path = :search_togo_inu_shitsuke_hiroba_entries_path
      @pre_entry_path = :togo_inu_shitsuke_hiroba_pre_entry_path
      @new_sns_account_path = :new_togo_inu_shitsuke_hiroba_sns_account_path
      @dogrun_name = :togo_inu_shitsuke_hiroba
      @sns_account_path = :togo_inu_shitsuke_hiroba_sns_account_path
      @edit_sns_account_path = :edit_togo_inu_shitsuke_hiroba_sns_account_path
      @form_selection_path = :togo_inu_shitsuke_hiroba_dog_registration_form_selection_path
      @have_registration_card_path = :togo_inu_shitsuke_hiroba_dog_registration_have_registration_card_path
      @not_have_registration_card_path = :togo_inu_shitsuke_hiroba_dog_registration_not_have_registration_card_path
      @dog_registration_path = :togo_inu_shitsuke_hiroba_dog_registration_path
      @dog_registration_confirm_path = :togo_inu_shitsuke_hiroba_dog_registration_confirm_path
      @new_article_path = :new_togo_inu_shitsuke_hiroba_article_path
      @article_path = :togo_inu_shitsuke_hiroba_article_path
      @new_embed_path = :new_togo_inu_shitsuke_hiroba_embed_path
      @embed_path = :togo_inu_shitsuke_hiroba_embed_path
      @dogrun_terms_of_service_page = "https://www.facebook.com/story.php?story_fbid=pfbid02NPCqT28XjCE6mcyBzvtmj8R7qmrqWfuzdtAVoS1LM1KnUa7j9jGafEHy7aHc2WMXl&id=100083200337421"
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
      redirect_to togo_inu_shitsuke_hiroba_signup_path, error: t('defaults.require_signup') unless !current_user.guest?
    end

end
