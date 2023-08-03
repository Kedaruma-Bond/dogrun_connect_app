# frozen_string_literal: true

class Dogs::ShowComponent < ApplicationViewComponent

  def initialize(
    title:, 
    registration_number_notation:, 
    current_user:, 
    dog:, 
    registration_number:, 
    user:, 
    encount_dog:, 
    edit_encount_dog_path:,
    dog_profile_path:, 
    edit_dog_path:,
    entries:,
    num_of_entry_records_to_display:,
    dogrun_place:,
    previous_path:
  )
    @title = title
    @registration_number_notation = registration_number_notation
    @current_user = current_user
    @dog = dog
    @registration_number = registration_number
    @user = user
    @encount_dog = encount_dog
    @edit_encount_dog_path = edit_encount_dog_path
    @dog_profile_path = dog_profile_path
    @edit_dog_path = edit_dog_path
    @entries = entries
    @num_of_entry_records_to_display = num_of_entry_records_to_display
    @dogrun_place = dogrun_place
    @previous_path = previous_path
  end

end
