# frozen_string_literal: true

class Dogs::ShowComponent < ApplicationViewComponent

  def initialize(
    dog:, 
    current_user:, 
    user:, 
    dog_profile_path:, 
    edit_dog_path:,
    entries:,
    num_of_entry_records_to_display:,
    dogrun_place:,
    encount_dog:,
    edit_encount_dog_path:,
    entries_record_analysis_path:,
    registration_number:
  )
    @dog = dog
    @current_user = current_user
    @user = user
    @dog_profile_path = dog_profile_path
    @edit_dog_path = edit_dog_path
    @entries = entries
    @num_of_entry_records_to_display = num_of_entry_records_to_display
    @dogrun_place = dogrun_place
    @encount_dog = encount_dog
    @edit_encount_dog_path = edit_encount_dog_path
    @entries_record_analysis_path = entries_record_analysis_path
    @registration_number = registration_number
  end

end
