# frozen_string_literal: true

class Articles::NewComponent < ViewComponent::Base
  def initialize(title:, article:)
    @title = title
    @article = article
    @article_path = article_path
    @top_path = top_path
  end
end
