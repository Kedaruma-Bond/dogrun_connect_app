# frozen_string_literal: true

class NoticeModalComponent < ViewComponent::Base
  include Turbo::FramesHelper
  
  def initialize(title:)
    @title = title
  end

end
