require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::StaticPagesController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }

  describe 'GET #top' do
    context 'ログインしているとき' do
      let!(:article) { create(:article, content: "test", post: create(:post, :article, :is_publishing, dogrun_place: dogrun_place)) } 

      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        get togo_inu_shitsuke_hiroba_top_path
      end

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include(article.content)
      end
    end

    context '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_top_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'ログインしていない時' do
      before { get togo_inu_shitsuke_hiroba_top_path }

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #top_contents' do
    
    context 'ログインしているとき' do
      let!(:other) { create(:user, :general) }
      let!(:dog_1) { create(:dog, :castrated, :public_view) }
      let!(:rn_1) { create(:registration_number, dog: dog_1, dogrun_place: dogrun_place) }
      let!(:entry_1) { create(:entry, registration_number: rn_1, dog: dog_1, exit_at: nil) }
      let!(:dog_2) { create(:dog, :castrated, :non_public, user: other) }
      let!(:rn_2) { create(:registration_number, dog: dog_2, dogrun_place: dogrun_place) }
      let!(:entry_2) { create(:entry, registration_number: rn_2, dog: dog_2, exit_at: nil) }

      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        get togo_inu_shitsuke_hiroba_top_contents_path
      end
      
      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include(entry_1.dog.name)
        expect(response.body).not_to include(entry_2.dog.name)
      end
    end
    
    context '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_top_contents_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていない時' do
      before { get togo_inu_shitsuke_hiroba_top_contents_path }
      
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
