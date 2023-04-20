# frozen_string_literal: true

class Users::RouteSelectionComponent < ApplicationViewComponent
  def initialize(
      title:, 
      current_user:,
      dogrun_place:,
      fully_route_path:,
      fully_form_selection_path:,
      fully_not_have_registration_card_path:,
      minimum_route_path:,
      form_selection_path:,
      not_have_registration_card_path:,
      notation_of_registration_card:,
      notation_of_registration_number:
    )
    @title = title
    @current_user = current_user
    @dogrun_place = dogrun_place
    @fully_route_path = fully_route_path
    @fully_form_selection_path = fully_form_selection_path
    @fully_not_have_registration_card_path = fully_not_have_registration_card_path
    @minimum_route_path = minimum_route_path
    @form_selection_path = form_selection_path
    @not_have_registration_card_path = not_have_registration_card_path
    @notation_of_registration_card = notation_of_registration_card
    @notation_of_registration_number = notation_of_registration_number
  end

end
