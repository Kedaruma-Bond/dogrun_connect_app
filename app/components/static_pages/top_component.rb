# frozen_string_literal: true

class StaticPages::TopComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end

end
