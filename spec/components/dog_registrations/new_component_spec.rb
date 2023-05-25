
require 'rails_helper'

RSpec.describe DogRegistrations::NewComponent, type: :component do
  let!(:title) { "Title" }

    
  example '正しくレンダリングされること' do
    render_inline(
      DogRegistrations::NewComponent.new(
        title: title
      )
    )
    expect(page).to have_css("p", text: title)
  end
end
