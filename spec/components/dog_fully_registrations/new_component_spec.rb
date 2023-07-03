require 'rails_helper'

RSpec.describe DogFullyRegistrations::NewComponent, type: :component do
  let!(:title) { "Title" }
  let!(:registration_number_notation) { "Number" }

  describe "session[:card_flg]がtrueの場合" do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ card_flg: true })
      render_inline(
        DogFullyRegistrations::NewComponent.new(
          title: title,
          registration_number_notation: registration_number_notation
        )
      )
    end

    example '正しくレンダリングされること' do
      expect(page).to have_css("p", text: title)
      expect(page).to have_text(registration_number_notation)
    end
  end

  describe "session[:card_flg]がfalseの場合" do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ card_flg: false })
      render_inline(
        DogFullyRegistrations::NewComponent.new(
          title: title,
          registration_number_notation: registration_number_notation
        )
      )
    end

    example '正しくレンダリングされること' do
      expect(page).to have_css("p", text: title)
      expect(page).not_to have_text(registration_number_notation)
    end
  end
end
