require 'rails_helper'

RSpec.describe RegistrationNumbers::EntriesRecordAnalysisComponent, type: :component do
  let!(:dogrun_place) { create(:dogrun_place) }
  let!(:user) { create(:user, :general) }
  let!(:dog) { create(:dog, :castrated, :public_view, user: user)}
  let!(:registration_number) { create(:registration_number, dog: dog, dogrun_place: dogrun_place) }
  let!(:entries_of_past_one_year) { [] }
  let!(:entries_monthly) { {"2022-09"=>0, "2022-10"=>0, "2022-11"=>0, "2022-12"=>0, "2023-01"=>0, "2023-02"=>0, "2023-03"=>0, "2023-04"=>0, "2023-05"=>0, "2023-06"=>0, "2023-07"=>0, "2023-08"=>3, "2023-09"=>13 } }
  let!(:notation_of_registration_number) { "パスポート番号" }

  describe '必要な引数が全て揃っている場合' do
    example '正しくレンダリングされること' do
      render_inline(
        RegistrationNumbers::EntriesRecordAnalysisComponent.new(
          registration_number: registration_number,
          dog: dog,
          entries_of_past_one_year: entries_of_past_one_year,
          entries_monthly: entries_monthly,
          notation_of_registration_number: notation_of_registration_number,
          dogrun_place: dogrun_place
        )
      )

      expect(page).to have_selector("div", text: notation_of_registration_number)
      expect(page).to have_selector("p", text: registration_number.registration_number)
      expect(page).to have_selector("h2", text: dog.name)
      expect(page).to have_selector("span", text: "0")

    end
  end
end
