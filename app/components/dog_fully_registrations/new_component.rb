# frozen_string_literal: true

class DogFullyRegistrations::NewComponent < ApplicationViewComponent
  def initialize(
    title:,
    registration_number_notation:
  )
    @title = title
    @registration_number_notation = registration_number_notation
  end
end
