require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::PreEntriesController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:dog) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number) { create(:registration_number, registration_number: "007", dog: dog, dogrun_place: dogrun_place) }
  let!(:pre_entry) { create(:pre_entry, dog: dog, registration_number: registration_number) }
  
  describe 'DELETE #destroy' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'pre_entryが削除されdogrunのtop画面にリダイレクトしてメッセージが表示されること' do
        delete togo_inu_shitsuke_hiroba_pre_entry_path
        expect(PreEntry.count).to be_zero
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
        expect(flash[:success]).to eq(I18n.t('local.pre_entries.pre_entries_canceled_successfully'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          delete togo_inu_shitsuke_hiroba_pre_entry_path
        }.not_to change(PreEntry, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
