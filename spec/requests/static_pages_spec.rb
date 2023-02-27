require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe '共通画面' do
    let!(:dogrun_place) { FactoryBot.create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
    context 'root pathにget request' do
      before { get root_path }

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      example 'タイトルがアプリ名のみになること' do
        expect(response.body).to include 'DogrunConnect'
      end
    end

    context 'private_policyにget request' do
      before { get privacy_policy_path }

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      example 'タイトルが正常に表示されること' do
        expect(response.body).to include(I18n.t('defaults.privacy_policy'))
        expect(response.body).to include '| DogrunConnect'
      end
    end

    context 'terms_of_serviceにget request' do
      before { get terms_of_service_path }

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      example 'タイトルが正常に表示さえれること' do
        expect(response.body).to include(I18n.t('defaults.terms_of_service'))
        expect(response.body).to include '| DogrunConnect'
      end
    end
  end

  describe '名前空間 togo_inu_shitsuke_hiroba' do
    let!(:dogrun_place) { FactoryBot.create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
    let!(:user) { FactoryBot.create(:user, :general) }

    describe 'ログイン前' do
      context 'togo_inu_shitsuke_hiroba/static_pages#topにget request' do
        before { get togo_inu_shitsuke_hiroba_top_path }
  
        example 'レスポンスが正常なこと' do
          expect(response).to have_http_status(:success)
        end
  
        example 'タイトルが正常に表示されていること' do
          expect(response.body).to include('犬のしつけ広場 | DogrunConnect')
        end
      end
    end

    describe 'ログイン後' do
      context 'togo_inu_shitsuke_hiroba/static_pages#detailにget request' do
        example 'レスポンスが正常なこと' do
          log_in_as(user)
          get togo_inu_shitsuke_hiroba_detail_path
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
