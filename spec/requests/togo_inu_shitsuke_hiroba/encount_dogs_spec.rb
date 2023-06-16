require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::EncountDogsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:other) { create(:user, :general) }
  let!(:dog) { create(:dog, :castrated, :public_view, user: other) }
  let!(:encount_dog) { create(:encount_dog, user: general, dogrun_place: dogrun_place, dog: dog ) }

  describe 'GET #index' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end
      example '正常なレスポンスがかえること' do
        get togo_inu_shitsuke_hiroba_encount_dogs_path
        expect(response).to have_http_status(:success)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_encount_dogs_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #edit' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end
      example '正常なレスポンスが返りackされること' do
        get edit_togo_inu_shitsuke_hiroba_encount_dog_path(encount_dog)
        expect(response).to have_http_status(:success)
        expect(encount_dog.reload.acknowledge).to eq(true)
      end
    end
    
    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get edit_togo_inu_shitsuke_hiroba_encount_dog_path(encount_dog)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'PATCH #update' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'データの更新され一覧ページにリダイレクトされること' do
        patch togo_inu_shitsuke_hiroba_encount_dog_path(encount_dog), params: { encount_dog: { memo: 'Updated memo' } }
        expect(encount_dog.reload.memo).to eq('Updated memo')
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_encount_dogs_path)
        expect(flash[:success]).to eq(I18n.t('local.encount_dogs.encount_dog_updated'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        patch togo_inu_shitsuke_hiroba_encount_dog_path(encount_dog)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #search' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正常なレスポンスが返ること' do
        get search_togo_inu_shitsuke_hiroba_encount_dogs_path
        expect(response).to have_http_status(:success)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get search_togo_inu_shitsuke_hiroba_encount_dogs_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'DELETE #destroy' do

    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'レコードが削除され一覧ページにリダイレクトされること' do
        expect {
          delete togo_inu_shitsuke_hiroba_encount_dog_path(encount_dog)
        }.to change(EncountDog, :count).by(-1)
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_encount_dogs_path)
        expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        delete togo_inu_shitsuke_hiroba_encount_dog_path(encount_dog)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
