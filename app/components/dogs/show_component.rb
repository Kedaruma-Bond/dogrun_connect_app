# frozen_string_literal: true

class Dogs::ShowComponent < ApplicationViewComponent

  def initialize(title:, registration_number_notation:, dog:, registration_number:, user:, encount_dog:, dog_profile_path:, edit_dog_path:)
    @title = title
    @registration_number_notation = registration_number_notation
    @dog = dog
    @registration_number = registration_number
    @user = user
    @encount_dog = encount_dog
    @dog_profile_path = dog_profile_path
    @edit_dog_path = edit_dog_path
  end

end
