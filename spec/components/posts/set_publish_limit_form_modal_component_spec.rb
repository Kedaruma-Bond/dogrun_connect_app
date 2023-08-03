require 'rails_helper'

RSpec.describe Posts::SetPublishLimitFormModalComponent, type: :component do
  let!(:title) { "title" }
  let!(:article) { create(:article)}
  let!(:post) { create(:post, :article, :is_publishing, article: article) }
  let!(:spinner_icon_for_form_disable_button) { "spinner" }
  
  example "正しくレンダリングされること" do
    render_inline(
      Posts::SetPublishLimitFormModalComponent.new(
        title: title,
        post: post,
        spinner_icon_for_form_disable_button: spinner_icon_for_form_disable_button
      )
    )
    expect(page).to have_selector("p", text: title)
    expect(page).to have_selector("div", text: article.content)
  end
end
