require 'rails_helper'

RSpec.describe RegistrationNumbers::NewComponent, type: :component do
  let!(:title) { "title" }
  
  describe 'dogsがblankの時' do
    let!(:dogs) { [] }
    example "正しくレンダリングできること" do
      render_inline(
        RegistrationNumbers::NewComponent.new(
          title: title,
          dogs: dogs
        )
      )
      expect(page).to have_selector("p", text: title)
      expect(page).to have_selector("p", text: I18n.t('local.registration_numbers.new.no_dogs_to_register'))
    end
  end

end
