# frozen_string_literal: true

class EncountDogs::EditComponent < ApplicationViewComponent
  def initialize(title:, encount_dog:)
    @title = title
    @encount_dog = encount_dog
  end

end
