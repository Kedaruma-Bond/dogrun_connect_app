# frozen_string_literal: true

class Articles::NewComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
