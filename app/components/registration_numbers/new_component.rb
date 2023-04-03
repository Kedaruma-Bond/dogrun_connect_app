# frozen_string_literal: true

class RegistrationNumbers::NewComponent < ApplicationViewComponent
  def initialize(
      title:, 
      dogs:, 
      user_path:, 
      current_user:
    )
    @title = title
    @dogs = dogs
    @user_path = user_path
    @current_user = current_user
  end

end
