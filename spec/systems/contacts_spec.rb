require 'rails_helper'

RSpec.describe 'contacts', type: :system do
  describe '正常系' do
    context '有効な値が入力されるとき' do
      before do
        visit new_contacts_path
        fill_in '氏名', with: 'Test User'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in '内容', with: 'hogehoge'
        click_button '入力内容確認'
      end

      it '入力内容確認画面が表示されること' do
        expect(page).to have_content('お問い合わせ内容確認')
      end

      it '正しい入力内容が表示されること' do
        expect(page).to have_content('Test User')
        expect(page).to have_content('test@example.com')
        expect(page).to have_content('hogehoge')
      end

      it '戻るボタンを押したら入力画面に戻ること' do
        click_button '戻る'
        expect(page).to have_content('お問い合わせ')
      end

      it '送信ボタンを押したらTop画面になりメッセージが表示すること' do
        click_button '送信'
        expect(page).to have_content('様々な付加価値があります')
        expect(page).to have_content('お問い合わせメールを送信しました')
      end
    end
  end
end
