# frozen_string_literal: true

class EncountDogs::ViewComponent < ApplicationViewComponent

  def initialize(
    title:, 
    pagy:, 
    q:, 
    applicable_path:, 
    current_path:,
    search_field_placeholder:
  )
    @title = title
    @pagy = pagy
    @q = q
    @applicable_path = applicable_path
    @current_path = current_path
    @search_field_placeholder = search_field_placeholder
  end

end
