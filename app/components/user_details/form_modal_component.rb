# frozen_string_literal: true

class UserDetails::FormModalComponent < ViewComponent::Base
  include Turbo::FramesHelper
  
  def initialize(title:)
    @title = title
  end
  
end
