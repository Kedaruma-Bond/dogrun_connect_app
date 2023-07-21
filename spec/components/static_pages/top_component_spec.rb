require 'rails_helper'

RSpec.describe StaticPages::TopComponent, type: :component do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:title) { "My Title" }
  let!(:publishing_post) { nil }
  let!(:dog_profile_path) { "root_path" }
  let!(:entry_path) { "root_path" }
  let!(:pre_entry_path) { "root_path" }
  let!(:jump_to_signup_path) { "root_path" }
  let!(:dogrun_terms_of_service_page) { "root_path" }
  let!(:login_path) { "root_path" }
  let!(:route_selection_path) { "root_path" }
  let!(:guest_login_path) { "root_path" }
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
  let!(:dogs_non_public) { [dog_2] }
  let!(:pre_entry_dogs_public_view) { [dog_3] }
  let!(:entry_for_time) { entry_1 }

  
  describe 'current_userがnilの時' do
    before do
      render_inline(
        StaticPages::TopComponent.new(
          title: title,
          dogrun_place: dogrun_place,
          current_user: nil,
          publishing_post: publishing_post,
          dogs: dogs,
          num_of_playing_dogs: num_of_playing_dogs,
          dogs_non_public: dogs_non_public,
          dog_profile_path: dog_profile_path,
          entry_path: entry_path,
          pre_entry_path: pre_entry_path,
          jump_to_signup_path: jump_to_signup_path,
          dogrun_terms_of_service_page: dogrun_terms_of_service_page,
          login_path: login_path,
          route_selection_path: route_selection_path,
          guest_login_path: guest_login_path,
          pre_entry_dogs_public_view: pre_entry_dogs_public_view,
          entries_path: entries_path,
          entry_for_time: entry_for_time,
        )
      )
    end
    example "与えたプロパティでコンポーネントがレンダリングされること" do
      expect(page).to have_css("a", text: I18n.t('local.static_pages.top.before_using_dogrun'))
      expect(page).to have_link(href: dogrun_terms_of_service_page)
      expect(page).to have_css("a", text: I18n.t('defaults.login'))
      expect(page).to have_link(href: login_path)
      expect(page).to have_css("a", text: I18n.t('defaults.signup'))
      expect(page).to have_link(href: route_selection_path)
      expect(page).to have_css("button", text: I18n.t('local.static_pages.top.guest_login'))
      expect(page).to have_link(href: guest_login_path)
    end
  end
  
  describe 'current_userがguestのとき' do
    before do
      render_inline(
        StaticPages::TopComponent.new(
          title: title,
          dogrun_place: dogrun_place,
          current_user: guest_user,
          publishing_post: publishing_post,
          dogs: dogs,
          num_of_playing_dogs: num_of_playing_dogs,
          dogs_non_public: dogs_non_public,
          dog_profile_path: dog_profile_path,
          entry_path: entry_path,
          pre_entry_path: pre_entry_path,
          jump_to_signup_path: jump_to_signup_path,
          dogrun_terms_of_service_page: dogrun_terms_of_service_page,
          login_path: login_path,
          route_selection_path: route_selection_path,
          guest_login_path: guest_login_path,
          pre_entry_dogs_public_view: pre_entry_dogs_public_view,
          entries_path: entries_path,
          entry_for_time: entry_for_time,
        )
      )
    end
    example "与えたプロパティでコンポーネントがレンダリングされること" do
      expect(page).to have_css("p", text: I18n.t('local.static_pages.top.site_in'))
      expect(page).to have_css("button", text: I18n.t('local.static_pages.top.jump_to_signup'))
      # confirm showing num of total palying dogs in dogrun
      expect(page).to have_css("h1", text: "2" )
      # confirm showing num of non public palying dogs in dogrun
      expect(page).to have_css("p", text: "1" )
    end
  end

  describe 'current_userがguest以外のとき' do
    before do
      render_inline(
        StaticPages::TopComponent.new(
          title: title,
          dogrun_place: dogrun_place,
          current_user: general_user,
          publishing_post: publishing_post,
          dogs: dogs,
          num_of_playing_dogs: num_of_playing_dogs,
          dogs_non_public: dogs_non_public,
          dog_profile_path: dog_profile_path,
          entry_path: entry_path,
          pre_entry_path: pre_entry_path,
          jump_to_signup_path: jump_to_signup_path,
          dogrun_terms_of_service_page: dogrun_terms_of_service_page,
          login_path: login_path,
          route_selection_path: route_selection_path,
          guest_login_path: guest_login_path,
          pre_entry_dogs_public_view: pre_entry_dogs_public_view,
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
