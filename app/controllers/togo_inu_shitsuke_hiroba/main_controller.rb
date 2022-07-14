class TogoInuShitsukeHiroba::MainController < ApplicationController
  def clear_entry_flag
    @entry_flag = false
  end

  private

  def set_dogs
    @dogs = Dog.where(user_id: current_user.id)
  end

  def set_registration_numbers
    @dogs.each do |dog|
      @registration_numbers = RegistrationNumber.where(dog_id: dog.id).merge(RegistrationNumber.where(dogrun_place: 'togo_inu_shitsuke_hiroba'))
    end
  end
end
