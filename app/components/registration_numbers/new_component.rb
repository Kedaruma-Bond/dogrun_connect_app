# frozen_string_literal: true

class RegistrationNumbers::NewComponent < ApplicationViewComponent
  def initialize(
      title:, 
      dogs: 
    )
    @title = title
    @dogs = dogs
  end

end
