require 'rails_helper'

RSpec.describe Embeds::NewComponent, type: :component do
  let!(:title) { "Title" }

  example "正しくレンダリングされること" do
    render_inline(
      Embeds::NewComponent.new(
        title: title
      )
    )
    expect(page).to have_selector("div", class: "text-2xl font-bold leading-7 text-center mb-5")
    expect(page).to have_selector("p", class: "text-sm font-medium text-center text-gray-600")
    expect(page).to have_link(href: "https://www.facebook.com/dogrunconnect/")
    expect(page).to have_link(href: "https://www.instagram.com/dogrun_connect/")
    expect(page).to have_link(href: "https://twitter.com/DogrunConnect")
  end
end
