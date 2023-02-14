# frozen_string_literal: true

class Dogs::EditComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end

end
