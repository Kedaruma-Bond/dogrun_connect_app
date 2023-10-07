# frozen_string_literal: true

class ArticlePosts::NewComponent < ApplicationViewComponent
  
  def initialize(title:)
    @title = title
  end
end
