require 'rails_helper'

RSpec.describe Dogs::EditComponent, type: :component do
  let!(:title) { "title" }

  example "正しくレンダリングされること" do
    render_inline(
      Dogs::EditComponent.new(
        title: title
      )
    )

    expect(page).to have_selector("p", class: "text-2xl md:text-3xl font-bold text-gray-700 text-center")
  end
end
