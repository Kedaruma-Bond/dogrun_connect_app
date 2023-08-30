require 'rails_helper'

describe StaticPages::TopContentsComponent, type: :component do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dog_profile_path) { "root_path" }
  let!(:pre_entry_path) { "root_path" }
  let!(:entries_path) { "root_path" }
  let!(:guest_user) { create(:user, :guest_user) }
  let!(:general_user) { create(:user, :general_user) }
  let!(:general_user_2) { create(:user, :general_user) }
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: general_user) }
  let!(:dog_2) { create(:dog, :castrated, :non_public, user: general_user) }
  let!(:dog_3) { create(:dog, :castrated, :public_view, user: general_user_2) }
  let!(:registration_number_1) { create(:registration_number, dog: dog_1, dogrun_place: dogrun_place)}
  let!(:registration_number_2) { create(:registration_number, dog: dog_2, dogrun_place: dogrun_place)}
  let!(:registration_number_3) { create(:registration_number, dog: dog_3, dogrun_place: dogrun_place)}
  let!(:entry_1) { create(:entry, dog: dog_1, registration_number: registration_number_1) }
  let!(:entry_2) { create(:entry, dog: dog_2, registration_number: registration_number_2) }
  let!(:pre_entry) { create(:pre_entry, dog: dog_3, registration_number: registration_number_3) }
  let!(:dogs) { [dog_1, dog_2] }
  let!(:num_of_playing_dogs) { 2 }
  let!(:entry_dogs_non_public) { [dog_2] }
  let!(:pre_entry_dogs_public_view_include_own_dog) { [dog_3] }
  let!(:entry_for_time) { entry_1 }

  
  describe 'current_userがguest以外のとき' do
    before do
      render_inline(
        StaticPages::TopContentsComponent.new(
          dogrun_place: dogrun_place,
          current_user: general_user,
          dogs: dogs,
          num_of_playing_dogs: num_of_playing_dogs,
          entry_dogs_non_public: entry_dogs_non_public,
          dog_profile_path: dog_profile_path,
          pre_entry_path: pre_entry_path,
          pre_entry_dogs_public_view_include_own_dog: pre_entry_dogs_public_view_include_own_dog,
          entries_path: entries_path,
          entry_for_time: entry_for_time,
        )
      )
    end
    example "与えたプロパティでコンポーネントがレンダリングされること" do
      expect(page).to have_css("p", text: I18n.t('local.static_pages.top.site_in'))
      # confirm showing num of total palying dogs in dogrun
      expect(page).to have_css("h1", text: "2" )
      # confirm showing num of non public palying dogs in dogrun
      expect(page).to have_css("p", text: "1" )
      expect(page).to have_css("turbo-frame", id: "login_top_content_dogrun_place_#{dogrun_place.id}" )
    end
  end
end
