class TogoInuShitsukeHiroba::StaticPagesController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  skip_before_action :require_login
  before_action :set_dog, only: %i[create update]
  before_action :set_registration_number, only: %i[create update]

  def top
    @entry = Entry.new
  end

  def compliance_confirmations; end

  private

  def set_dog
    @dog = Dog.where(user_id: current_user.id)
  end

  def set_registration_number
    @registration_number = RegistrationNumber.where(dog_id: @dog.id).merge(RegistrationNumber.where(dogrun_place: 'togo_inu_shitsuke_hiroba'))
  end
end
