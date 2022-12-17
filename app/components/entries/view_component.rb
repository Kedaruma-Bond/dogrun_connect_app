# frozen_string_literal: true

class Entries::ViewComponent < ViewComponent::Base
  def initialize(title:, pagy:)
    @title = title
    @pagy = pagy
  end

end
