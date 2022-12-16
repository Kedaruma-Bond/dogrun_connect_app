# frozen_string_literal: true

class EntriesViewComponent < ViewComponent::Base

  def initialize(title:, pagy:)
    @title = title
    @pagy = pagy
  end

end
