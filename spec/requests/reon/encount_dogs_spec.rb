require 'rails_helper'

RSpec.describe Reon::EncountDogsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }
  let!(:other) { create(:user, :general) }
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: other) }
  let!(:dog_2) { create(:dog, :castrated, :public_view, user: general) }
  let!(:encount_dog_1) { create(:encount_dog, user: general, dogrun_place: dogrun_place, dog: dog_1 ) }
  let!(:encount_dog_2) { create(:encount_dog, user: other, dogrun_place: dogrun_place, dog: dog_2 ) }

  describe 'GET #index' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end
      example '正常なレスポンスがかえること' do
        get reon_encount_dogs_path
        expect(response).to have_http_status(:success)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get reon_encount_dogs_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get reon_encount_dogs_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #edit' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      context 'ログインしているアカウントに紐づいたdataをeditする場合' do
        example '正常なレスポンスが返りackされること' do
          get edit_reon_encount_dog_path(encount_dog_1)
          expect(response).to have_http_status(:success)
          expect(encount_dog_1.reload.acknowledge).to eq(true)
        end
      end

      context '別のアカウントに紐づいたdataをeditする場合' do
        example '表示されないこと' do
          get edit_reon_encount_dog_path(encount_dog_2)
          expect(response).to redirect_to(reon_encount_dogs_path)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get edit_reon_encount_dog_path(encount_dog_1)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get edit_reon_encount_dog_path(encount_dog_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'PATCH #update' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      context 'ログインしているアカウントに紐づいたdataをupdateする場合' do
        example 'データの更新され一覧ページにリダイレクトされること' do
          patch reon_encount_dog_path(encount_dog_1), params: { encount_dog: { memo: 'Updated memo' } }
          expect(encount_dog_1.reload.memo).to eq('Updated memo')
          expect(response).to redirect_to(reon_encount_dogs_path)
          expect(flash[:success]).to eq(I18n.t('local.encount_dogs.encount_dog_updated'))
        end
      end

      context '別のアカウントに紐づいたdataをupdateする場合' do
        example '更新できないこと' do
          patch reon_encount_dog_path(encount_dog_2), params: { encount_dog: { memo: 'Updated memo' } }
          expect(encount_dog_2.reload.memo).not_to eq('Updated memo')
          expect(response).to redirect_to(reon_encount_dogs_path)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        patch reon_encount_dog_path(encount_dog_1)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        patch reon_encount_dog_path(encount_dog_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #search' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example '正常なレスポンスが返ること' do
        get search_reon_encount_dogs_path
        expect(response).to render_template(:search)
        expect(response).to have_http_status(:success)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get search_reon_encount_dogs_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get search_reon_encount_dogs_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'DELETE #destroy' do

    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      context 'ログインしているアカウントに紐づいたdataを削除する場合' do
        example 'レコードが削除され一覧ページにリダイレクトされること' do
          expect {
            delete reon_encount_dog_path(encount_dog_1)
          }.to change(EncountDog, :count).by(-1)
          expect(response).to redirect_to(reon_encount_dogs_path)
          expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
        end
      end

      context '別のアカウントに紐づいたdataを削除する場合' do
        example '削除できないこと' do
          expect {
            delete reon_encount_dog_path(encount_dog_2)
          }.not_to change(EncountDog, :count)
          expect(response).to redirect_to(reon_encount_dogs_path)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect {
          delete reon_encount_dog_path(encount_dog_1)
        }.not_to change(EncountDog, :count)
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        delete reon_encount_dog_path(encount_dog_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
