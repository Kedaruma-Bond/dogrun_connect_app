# frozen_string_literal: true

class Users::ShowComponent < ApplicationViewComponent
  def initialize(
      title:, 
      current_user:, 
      dogs:, 
      num_of_encount_dogs:, 
      dog_registration_path:, 
      new_registration_number_path:
    )
    @title = title
    @current_user = current_user
    @dogs = dogs
    @num_of_encount_dogs = num_of_encount_dogs
    @dog_registration_path = dog_registration_path
    @new_registration_number_path = new_registration_number_path
  end

end
