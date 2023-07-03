# frozen_string_literal: true

class StaticPages::TopComponent < ApplicationViewComponent
  def initialize(
    title:,
    dogrun_place:,
    current_user:,
    publishing_post:,
    dogs:,
    num_of_playing_dogs:,
    dogs_non_public:,
    dog_profile_path:,
    entry_path:,
    pre_entry_path:,
    jump_to_signup_path:,
    dogrun_terms_of_service_page:,
    login_path:,
    route_selection_path:,
    guest_login_path:,
    pre_entry_dogs_public_view:,
    entries_path:
    )
    @title = title
    @dogrun_place = dogrun_place
    @current_user = current_user
    @publishing_post = publishing_post
    @dogs = dogs
    @num_of_playing_dogs = num_of_playing_dogs
    @dogs_non_public = dogs_non_public
    @dog_profile_path = dog_profile_path
    @entry_path = entry_path
    @pre_entry_path = pre_entry_path
    @jump_to_signup_path = jump_to_signup_path
    @dogrun_terms_of_service_page = dogrun_terms_of_service_page
    @login_path = login_path
    @route_selection_path = route_selection_path
    @guest_login_path = guest_login_path
    @pre_entry_dogs_public_view = pre_entry_dogs_public_view
    @entries_path = entries_path
  end

end
