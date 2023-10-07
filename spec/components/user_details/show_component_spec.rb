require 'rails_helper'

RSpec.describe UserDetails::ShowComponent, type: :component do
  let!(:user) { create(:user, :general) }
  let!(:user_detail) { create(:user_detail, user: user) }
  let!(:edit_user_detail_path) { "root_path" }
  let!(:user_detail_path) { "root_path" }

  example '正しくレンダリングされること' do
    render_inline(
      UserDetails::ShowComponent.new(
        user_detail: user_detail,
        edit_user_detail_path: edit_user_detail_path,
        user_detail_path: user_detail_path
      )
    )

    expect(page).to have_selector("button", class:"cursor-default w-full h-full fixed inset-0 bg-gray-700 bg-opacity-50")
  end

end
