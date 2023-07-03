require 'rails_helper'

RSpec.describe SnsAccounts::FormModalComponent, type: :component do
  let!(:title) { "title" }
  
  example "正しくレンダリングできること" do
    render_inline(
      SnsAccounts::FormModalComponent.new(
        title: title
      )
    )
    expect(page).to have_selector("p", text: title)
  end

end
