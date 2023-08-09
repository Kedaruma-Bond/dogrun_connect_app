# frozen_string_literal: true

class StaticPages::TopComponent < ApplicationViewComponent
  def initialize(
    title:,
    dogrun_place:,
    current_user:,
    publishing_post:,
    jump_to_signup_path:,
    dogrun_terms_of_service_page:,
    login_path:,
    route_selection_path:,
    guest_login_path:
    )
    @title = title
    @dogrun_place = dogrun_place
    @current_user = current_user
    @publishing_post = publishing_post
    @jump_to_signup_path = jump_to_signup_path
    @dogrun_terms_of_service_page = dogrun_terms_of_service_page
    @login_path = login_path
    @route_selection_path = route_selection_path
    @guest_login_path = guest_login_path
  end

end
