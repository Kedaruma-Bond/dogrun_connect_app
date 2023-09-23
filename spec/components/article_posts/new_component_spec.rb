require 'rails_helper'

RSpec.describe ArticlePosts::NewComponent, type: :component do
  let!(:title) { "Title" }

  example '正しくレンダリングされること' do
    render_inline(
      ArticlePosts::NewComponent.new(
        title: title
      )
    )
    expect(page).to have_selector("div", text: title)
  end
end
