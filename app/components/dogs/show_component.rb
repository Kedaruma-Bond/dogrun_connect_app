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
    dogrun_place:
  )
    @dog = dog
    @current_user = current_user
    @user = user
    @dog_profile_path = dog_profile_path
    @edit_dog_path = edit_dog_path
    @entries = entries
    @num_of_entry_records_to_display = num_of_entry_records_to_display
    @dogrun_place = dogrun_place
  end

end
