# frozen_string_literal: true

class EncountDogs::ViewComponent < ApplicationViewComponent

  def initialize(title:, pagy:)
    @title = title
    @pagy = pagy
  end

end
