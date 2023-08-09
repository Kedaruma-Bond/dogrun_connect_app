require 'rails_helper'

RSpec.describe Reon::PreEntriesController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }
  let!(:dog) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number) { create(:registration_number, registration_number: "007", dog: dog, dogrun_place: dogrun_place) }
  let!(:pre_entry) { create(:pre_entry, dog: dog, registration_number: registration_number) }
  
  describe 'DELETE #destroy' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example 'pre_entryが削除されdogrunのtop画面にリダイレクトしてメッセージが表示されること' do
        delete reon_pre_entry_path
        expect(PreEntry.count).to be_zero
        expect(response).to redirect_to(reon_top_path)
        expect(flash[:success]).to eq(I18n.t('local.pre_entries.pre_entries_canceled_successfully'))
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect {
          delete reon_pre_entry_path
        }.not_to change(PreEntry, :count)
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          delete reon_pre_entry_path
        }.not_to change(PreEntry, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
