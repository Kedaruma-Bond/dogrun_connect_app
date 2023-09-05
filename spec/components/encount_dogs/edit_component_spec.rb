require 'rails_helper'

RSpec.describe EncountDogs::EditComponent, type: :component do
  let!(:title) { "title" }
  let!(:dogrun_place) { create(:dogrun_place) }
  let!(:user) { create(:user, :general_user)}
  let!(:dog) { create(:dog, :castrated, :public_view, user: user) }
  let!(:encount_dog) {create(:encount_dog, dog: dog, user: user, dogrun_place: dogrun_place) }

  example "正しくレンダリングされること" do
    render_inline(
      EncountDogs::EditComponent.new(
        title: title,
        encount_dog: encount_dog
      )
    )

    expect(page).to have_selector("div", class: "relative bg-slate-300 p-2 absolute shadow-xl rounded-lg border-2 border-gray-700 dark:border-white w-full md:w-96 backdrop-blur bg-opacity-75")
    expect(page).to have_selector("p", text: I18n.t("local.encount_dogs.edit.encount_dog_name"))
    expect(page).to have_selector("p", text: dog.name)
  end
end
