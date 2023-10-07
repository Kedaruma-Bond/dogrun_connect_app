# frozen_string_literal: true

class UserDetails::ShowComponent < ApplicationViewComponent
  def initialize(
    user_detail:,
    edit_user_detail_path:,
    user_detail_path:
  )
    @user_detail = user_detail
    @edit_user_detail_path = edit_user_detail_path
    @user_detail_path = user_detail_path
  end

end
