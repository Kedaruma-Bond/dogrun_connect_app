require 'rails_helper'

RSpec.describe DogRegistrations::FormSelectionComponent, type: :component do
  let!(:title) { "Title" }
  let!(:confirmation) { "Confirmation" }
  let!(:have_registration_card_path) { "privacy_policy_path" }
  let!(:not_have_registration_card_path) { "terms_of_service_path" }

    
  describe "dogrunにregistration_cardが登録されている場合" do
    let!(:dogrun_place) { create(:dogrun_place, :with_images) }
    example '正しくレンダリングされること' do
      render_inline(
        DogRegistrations::FormSelectionComponent.new(
          title: title,
          confirmation: confirmation,
          dogrun_place: dogrun_place,
          have_registration_card_path: have_registration_card_path,
          not_have_registration_card_path: not_have_registration_card_path
        )
      )
      expect(page).to have_selector("p", text: confirmation)
      expect(page).to have_selector("a", text: I18n.t('simple_form.yes'))
      expect(page).to have_link(href: "/privacy_policy" )
      expect(page).to have_selector("a", text: I18n.t('simple_form.no'))
      expect(page).to have_link(href: "/terms_of_service" )
    end
  end
end
