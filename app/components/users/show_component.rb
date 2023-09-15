# frozen_string_literal: true

class Users::ShowComponent < ApplicationViewComponent
  def initialize(
      title:, 
      dogrun_place:,
      current_user:, 
      dogs:, 
      dog_profile_path:,
      registration_numbers:,
      registration_number_path:,
      num_of_encount_dogs:, 
      route_selection_path:,
      new_registration_number_path:,
      rns_form_selection_path:,
      notation_of_registration_number:
    )
    @title = title
    @dogrun_place = dogrun_place
    @current_user = current_user
    @dogs = dogs
    @dog_profile_path = dog_profile_path
    @registration_numbers = registration_numbers
    @registration_number_path = registration_number_path
    @num_of_encount_dogs = num_of_encount_dogs
    @route_selection_path = route_selection_path
    @new_registration_number_path = new_registration_number_path
    @rns_form_selection_path = rns_form_selection_path
    @notation_of_registration_number = notation_of_registration_number
  end

end
