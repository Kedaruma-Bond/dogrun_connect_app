# frozen_string_literal: true

class RegistrationNumbers::EntriesRecordAnalysisComponent < ApplicationViewComponent
  def initialize(
    registration_number:,
    dog:, 
    entries_of_past_one_year:, 
    entries_monthly:,
    notation_of_registration_number:,
    dogrun_place:
  )
    @registration_number = registration_number
    @dog = dog
    @entries_of_past_one_year = entries_of_past_one_year
    @entries_monthly = entries_monthly
    @notation_of_registration_number = notation_of_registration_number
    @dogrun_place = dogrun_place
  end

end
