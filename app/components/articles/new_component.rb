# frozen_string_literal: true

class Articles::NewComponent < ApplicationViewComponent
  
  def initialize(title:)
    @title = title
  end
end
