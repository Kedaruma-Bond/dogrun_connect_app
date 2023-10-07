require 'rails_helper'

RSpec.describe Dogs::ShowComponent, type: :component do
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: current_user, birthday: "") }
  let!(:dog_2) { create(:dog, :castrated, :public_view, user: user, birthday: "") }
  let!(:current_user) { create(:user, :general) }
  let!(:user) { create(:user, :general) }
  let!(:dog_profile_path) { "privacy_policy_path" }
  let!(:edit_dog_path) { "edit_reon_dog_path" }
  let!(:entries) { [] }
  let!(:num_of_entry_records_to_display) { 5 }
  let!(:dogrun_place) { create(:dogrun_place)}
  let!(:encount_dog) { create(:encount_dog, dog: dog_2, user: current_user, dogrun_place: dogrun_place) }  
  let!(:edit_encount_dog_path) { "root_path" }  
  let!(:entries_record_analysis_path) { "root_path" }
  let!(:registration_number) { create(:registration_number, dog: dog_1, dogrun_place: dogrun_place) }

  describe 'current_userが飼い主のdogの場合' do
    example '正しくレンダリングされること' do
      render_inline(
        Dogs::ShowComponent.new(
          dog: dog_1,
          current_user: current_user,
          user: current_user,
          dog_profile_path: dog_profile_path,
          edit_dog_path: edit_dog_path,
          entries: entries,
          num_of_entry_records_to_display: num_of_entry_records_to_display,
          dogrun_place: dogrun_place,
          encount_dog: encount_dog,
          edit_encount_dog_path: edit_encount_dog_path,
          entries_record_analysis_path: entries_record_analysis_path,
          registration_number: registration_number
        )
      )

      expect(page).to have_link(href: "/reon/dogs/#{dog_1.id}/edit" )
    end
  end

  describe 'current_userが飼い主以外のdogの場合' do
    example '正しくレンダリングされること' do
      render_inline(
        Dogs::ShowComponent.new(
          dog: dog_2,
          current_user: current_user,
          user: user,
          dog_profile_path: dog_profile_path,
          edit_dog_path: edit_dog_path,
          entries: entries,
          num_of_entry_records_to_display: num_of_entry_records_to_display,
          dogrun_place: dogrun_place,
          encount_dog: encount_dog,
          edit_encount_dog_path: edit_encount_dog_path,
          entries_record_analysis_path: entries_record_analysis_path,
          registration_number: registration_number
        )
      )

      expect(page).not_to have_link(href: "/reon/dogs/#{dog_2.id}/edit" )
    end

  end
end
