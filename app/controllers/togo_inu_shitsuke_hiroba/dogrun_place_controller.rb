class TogoInuShitsukeHiroba::DogrunPlaceController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  
  private

  def set_registration_numbers_in_togo_inu_shitsuke_hiroba
    return unless logged_in?

    @registration_numbers = []
    @dogs.each do |dog|
      registration_number = RegistrationNumber.where(dog_id: dog.id).merge(RegistrationNumber.where(dogrun_place_id: 2))
      @registration_numbers += registration_number
    end
  end
end
