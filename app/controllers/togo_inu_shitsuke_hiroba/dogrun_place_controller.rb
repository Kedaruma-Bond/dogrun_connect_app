class TogoInuShitsukeHiroba::DogrunPlaceController < ApplicationController
  private

  def set_registration_numbers
    return unless logged_in?

    @dogs.each do |dog|
      @registration_numbers = RegistrationNumber.where(dog_id: dog.id).merge(RegistrationNumber.where(dogrun_place: 'togo_inu_shitsuke_hiroba'))
    end
  end
end
