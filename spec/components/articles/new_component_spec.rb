require 'rails_helper'

RSpec.describe Articles::NewComponent, type: :component do
  let!(:title) { "Title" }

  example '正しくレンダリングされること' do
    render_inline(
      Articles::NewComponent.new(
        title: title
      )
    )
    expect(page).to have_selector("div", text: title)
  end
end
