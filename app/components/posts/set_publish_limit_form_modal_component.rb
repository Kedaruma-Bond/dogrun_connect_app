# frozen_string_literal: true

class Posts::SetPublishLimitFormModalComponent < ApplicationViewComponent
  def initialize(title:, post:, spinner_icon_for_form_disable_button:)
    @title = title
    @post = post
    @spinner_icon_for_form_disable_button = spinner_icon_for_form_disable_button
  end

end
