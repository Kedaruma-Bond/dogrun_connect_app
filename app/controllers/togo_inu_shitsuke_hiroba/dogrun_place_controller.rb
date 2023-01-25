class TogoInuShitsukeHiroba::DogrunPlaceController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  before_action :set_dogrun_place
  
  private
  
    def set_dogrun_place
      @dogrun_place = DogrunPlace.find(2)
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
