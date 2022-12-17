# frozen_string_literal: true

class Users::AdminViewComponent < ViewComponent::Base
  def initialize(title:, pagy:)
    @title = title
    @pagy = pagy
  end

end
