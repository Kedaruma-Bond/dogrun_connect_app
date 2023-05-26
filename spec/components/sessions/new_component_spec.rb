require 'rails_helper'

RSpec.describe Sessions::NewComponent, type: :component do
  let!(:title) { "title" }
  
  example "正しくレンダリングできること" do
    render_inline(
      Sessions::NewComponent.new(
        title: title
      )
    )
    expect(page).to have_selector("p", text: title)
  end

end
