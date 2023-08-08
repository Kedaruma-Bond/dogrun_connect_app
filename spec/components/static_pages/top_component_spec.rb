require 'rails_helper'

RSpec.describe StaticPages::TopComponent, type: :component do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:title) { "My Title" }
  let!(:article) { create(:article, content: "test", post: create(:post, :article, :is_publishing, dogrun_place: dogrun_place)) } 
  let!(:publishing_post) { [article.post] }
  let!(:dog_profile_path) { "root_path" }
  let!(:pre_entry_path) { "root_path" }
  let!(:jump_to_signup_path) { "root_path" }
  let!(:dogrun_terms_of_service_page) { "root_path" }
  let!(:login_path) { "root_path" }
  let!(:route_selection_path) { "root_path" }
  let!(:guest_login_path) { "root_path" }
  let!(:entries_path) { "root_path" }
  let!(:guest_user) { create(:user, :guest_user) }
  let!(:general_user) { create(:user, :general_user) }

  
  describe 'current_userがnilの時' do
    before do
      render_inline(
        StaticPages::TopComponent.new(
          title: title,
          dogrun_place: dogrun_place,
          current_user: nil,
          publishing_post: publishing_post,
          jump_to_signup_path: jump_to_signup_path,
          dogrun_terms_of_service_page: dogrun_terms_of_service_page,
          login_path: login_path,
          route_selection_path: route_selection_path,
          guest_login_path: guest_login_path,
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
          jump_to_signup_path: jump_to_signup_path,
          dogrun_terms_of_service_page: dogrun_terms_of_service_page,
          login_path: login_path,
          route_selection_path: route_selection_path,
          guest_login_path: guest_login_path,
        )
      )
    end
    example "与えたプロパティでコンポーネントがレンダリングされること" do
      expect(page).to have_css("button", text: I18n.t('local.static_pages.top.jump_to_signup'))
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
          jump_to_signup_path: jump_to_signup_path,
          dogrun_terms_of_service_page: dogrun_terms_of_service_page,
          login_path: login_path,
          route_selection_path: route_selection_path,
          guest_login_path: guest_login_path,
        )
      )
    end
    example "与えたプロパティでコンポーネントがレンダリングされること" do
      expect(page).to have_css("turbo-frame", id: "top_contents_dogrun_place_#{dogrun_place.id}" )
      expect(page).to have_css("div", text: article.content )
    end
  end
end
