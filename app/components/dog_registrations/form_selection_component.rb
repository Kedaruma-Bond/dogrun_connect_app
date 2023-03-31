# frozen_string_literal: true

class DogRegistrations::FormSelectionComponent < ApplicationViewComponent
  def initialize(
      title:,
      confirmation:,
      dogrun_place:,
      have_registration_card_path:, 
      not_have_registration_card_path:
    )
    @title = title
    @confirmation = confirmation
    @dogrun_place = dogrun_place
    @have_registration_card_path = have_registration_card_path
    @not_have_registration_card_path = not_have_registration_card_path
  end

end
