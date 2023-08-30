require 'rails_helper'

RSpec.describe 'contacts', type: :system do
  let!(:dogrun_place_2) { create(:dogrun_place, :togo_inu_shitsuke_hiroba, id: 2) }
  let!(:dogrun_place_3) { create(:dogrun_place, :reon, id: 3) }
  describe '正常系' do
    context '有効な値が入力されるとき' do
      before do
        visit new_contacts_path
        fill_in 'contact[name]', with: 'Test User'
        fill_in 'contact[email]', with: 'test@example.com'
        fill_in 'contact[message]', with: 'hogehoge'
        button_text = I18n.t('defaults.confirm')
        button = find_button(button_text)
        button.click
      end

      example '入力内容確認画面が表示されること' do
        expect(page).to have_content(I18n.t('contacts.confirm.title'))
      end

      example '正しい入力内容が表示されること' do
        expect(page).to have_content('Test User')
        expect(page).to have_content('test@example.com')
        expect(page).to have_content('hogehoge')
      end

      example '戻るボタンを押したら入力画面に戻ること' do
        button_text = I18n.t('defaults.back')
        button = find_link(button_text)
        button.click
        expect(page).to have_content(I18n.t('contacts.new.title'))
        expect(page).to have_field('contact[name]', with: 'Test User')
        expect(page).to have_field('contact[email]', with: 'test@example.com')
        expect(page).to have_field('contact[message]', with: 'hogehoge')
      end

      example '送信ボタンを押したらTop画面遷移すること' do
        button_text = I18n.t('defaults.post')
        button = find_button(button_text)
        accept_confirm do
          button.click
        end
        expect(page).to have_content('ドッグランに導入して利用記録をDX化')
        expect(page).to have_content('お問い合わせメールを')
      end
    end
  end

  describe '異常系' do
    context '無効な値が入力されるとき' do
      before do
        visit new_contacts_path
        fill_in 'contact[name]', with: ''
        fill_in 'contact[email]', with: 'test'
        fill_in 'contact[message]', with: ''
        button_text = I18n.t('defaults.confirm')
        button = find_button(button_text)
        button.click
      end
      
      example '入力内容確認画面が表示されないこと' do
        expect(page).not_to have_content(I18n.t('contacts.confirm.title'))
        expect(page).to have_content(I18n.t('contacts.new.title'))
      end

      example 'validation errorが表記されていること' do
        expect(page).to have_selector('#error_explanation')
        expect(page).to have_content('氏名を入力してください')
        expect(page).to have_content('メールアドレスの様式が正しくありません')
        expect(page).to have_content('内容を入力してください')
      end
    end
  end
end
