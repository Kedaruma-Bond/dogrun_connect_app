require 'rails_helper'

RSpec.describe Dogs::ShowComponent, type: :component do
  let!(:dogrun_place) { create(:dogrun_place)}
  let!(:title) { "Title" }
  let!(:registration_number_notation) { "registration_number" }
  let!(:current_user) { create(:user, :general) }
  let!(:user) { create(:user, :general) }
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: current_user, birthday: "") }
  let!(:dog_2) { create(:dog, :castrated, :public_view, user: user, birthday: "") }
  let!(:registration_number_1) { create(:registration_number, dog: dog_1, dogrun_place: dogrun_place) }
  let!(:registration_number_2) { create(:registration_number, dog: dog_2, dogrun_place: dogrun_place) }
  let!(:encount_dog) { create(:encount_dog, user: current_user, dog: dog_2, dogrun_place: dogrun_place) }
  let!(:dog_profile_path) { "privacy_policy_path" }
  let!(:edit_dog_path) { "edit_reon_dog_path" }
  let!(:num_of_entry_records_to_display) { 5 }
  let!(:entries) { [] }

  describe 'current_userが飼い主のdogの場合' do
    example '正しくレンダリングされること' do
      render_inline(
        Dogs::ShowComponent.new(
          title: title,
          registration_number_notation: registration_number_notation,
          current_user: current_user,
          user: current_user,
          dog: dog_1,
          registration_number: registration_number_1,
          encount_dog: encount_dog,
          dog_profile_path: dog_profile_path,
          edit_dog_path: edit_dog_path,
          entries: entries,
          num_of_entry_records_to_display: num_of_entry_records_to_display
        )
      )

      expect(page).to have_selector("p", text: title)
      expect(page).to have_selector("div", text: registration_number_notation)
      expect(page).to have_selector("p", text: registration_number_1.registration_number)
      expect(page).to have_selector("h2", text: dog_1.name)
      expect(page).to have_selector("span", text: I18n.t("defaults.edit"))
      expect(page).to have_link(href: "/reon/dogs/#{dog_1.id}/edit" )
    end
  end

  describe 'current_userが飼い主以外のdogの場合' do
    example '正しくレンダリングされること' do
      render_inline(
        Dogs::ShowComponent.new(
          title: title,
          registration_number_notation: registration_number_notation,
          current_user: current_user,
          user: user,
          dog: dog_2,
          registration_number: registration_number_2,
          encount_dog: encount_dog,
          dog_profile_path: dog_profile_path,
          edit_dog_path: edit_dog_path,
          entries: entries,
          num_of_entry_records_to_display: num_of_entry_records_to_display
        )
      )

      expect(page).to have_selector("p", text: title)
      expect(page).to have_selector("div", text: registration_number_notation)
      expect(page).to have_selector("p", text: registration_number_2.registration_number)
      expect(page).to have_selector("h2", text: dog_2.name)
      expect(page).not_to have_selector("span", text: I18n.t("defaults.edit"))
      expect(page).not_to have_link(href: "/reon/dogs/#{dog_2.id}/edit" )
      expect(page).to have_selector("p", text: I18n.t('defaults.encount_dog_memo') )
    end

  end
end
