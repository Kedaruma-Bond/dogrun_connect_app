require 'rails_helper'

RSpec.describe StaticPages::TopComponent, type: :component do
  let!(:dogrun_place) { build(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:title) { "My Title" }
  let(:publishing_post) { nil }
  let(:dogs) { [] }
  let(:num_of_playing_dogs) { 0 }
  let(:dogs_non_public) { [] }
  let(:dog_profile_path) { "/" }
  let(:entry_path) { "/" }
  let(:pre_entry_path) { "/" }
  let(:jump_to_signup_path) { "/" }
  let(:dogrun_terms_of_service_page) { "/" }
  let(:login_path) { "/" }
  let(:route_selection_path) { "/" }
  let(:guest_login_path) { "/" }
  
  before do
    # データベースにオブジェクトを保存する
    dogrun_place.save!
    # @dogrun_placeにオブジェクトを設定する
    @dogrun_place = dogrun_place
  end

  example "与えたプロパティでコンポーネントがレンダリングされること" do
    render_inline(
      StaticPages::TopComponent.new(
        title: title,
        dogrun_place: dogrun_place,
        current_user: general,
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
        guest_login_path: guest_login_path
      )
    )

    expect(rendered_component).to have_css("h1", text: title)
    expect(rendered_component).to have_css("div", text: dogrun_place)
  end
end
