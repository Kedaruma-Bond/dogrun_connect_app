# frozen_string_literal: true

class Sessions::NewComponent < ApplicationViewComponent
  def initialize(title:)
    @title = title
  end

end
