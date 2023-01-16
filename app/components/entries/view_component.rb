# frozen_string_literal: true

class Entries::ViewComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(title:, pagy:)
    @title = title
    @pagy = pagy
  end

end
