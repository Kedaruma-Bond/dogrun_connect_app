# frozen_string_literal: true

class Entries::ViewComponent < ApplicationViewComponent

  def initialize(
    title:, 
    pagy:, 
    q:, 
    applicable_path:, 
    current_path:,
    search_field_placeholder:, 
    dogrun_place:
  )
    @title = title
    @pagy = pagy
    @q = q
    @applicable_path = applicable_path
    @current_path = current_path
    @search_field_placeholder = search_field_placeholder
    @dogrun_place = dogrun_place
  end

end
