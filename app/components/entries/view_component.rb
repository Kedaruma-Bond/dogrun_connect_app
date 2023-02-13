# frozen_string_literal: true

class Entries::ViewComponent < ApplicationViewComponent

  def initialize(title:, pagy:)
    @title = title
    @pagy = pagy
  end

end
