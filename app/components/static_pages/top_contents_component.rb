# frozen_string_literal: true

class StaticPages::TopContentsComponent < ApplicationViewComponent
  def initialize(
    dogrun_place:, 
    current_user:, 
    dogs:, 
    num_of_playing_dogs:, 
    entry_dogs_non_public:, 
    dog_profile_path:, 
    pre_entry_path:, 
    pre_entry_dogs_public_view_include_own_dog:, 
    entries_path:, 
    entry_for_time:
  )
    @dogrun_place = dogrun_place
    @current_user = current_user
    @dogs = dogs
    @num_of_playing_dogs = num_of_playing_dogs
    @entry_dogs_non_public = entry_dogs_non_public
    @dog_profile_path = dog_profile_path
    @pre_entry_path = pre_entry_path
    @pre_entry_dogs_public_view_include_own_dog = pre_entry_dogs_public_view_include_own_dog
    @entries_path = entries_path
    @entry_for_time = entry_for_time
  end

end
