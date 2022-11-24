class TogoInuShitsukeHiroba::DogrunPlaceController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  before_action :set_dogrun_place

  
  private
  
    def set_dogrun_place
      @dogrun_place = DogrunPlace.find(2)
    end
  
    def set_dogs_and_registration_numbers_at_local
      return unless logged_in?
      
      @dogs = Dog.with_attached_thumbnail.joins(:registration_numbers).where(registration_numbers: { dogrun_place_id: 2 }).where(user_id: current_user.id).order(:id)
      @registration_numbers = @dogs.map do |dog|
        RegistrationNumber.find_by(dog_id: dog.id)
      end
    end
    
    def set_staffs
      @staffs = Staff.where(dogrun_place_id: 2).enable
    end

    def skip_bullet
      previous_value = Bullet.enable?
      Bullet.enable = false
      yield
    ensure
      Bullet.enable = previous_value
    end
end
