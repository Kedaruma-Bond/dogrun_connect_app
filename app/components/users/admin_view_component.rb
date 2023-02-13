# frozen_string_literal: true

class Users::AdminViewComponent < ApplicationViewComponent
  def initialize(title:, pagy:)
    @title = title
    @pagy = pagy
  end

end
