require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe '共通画面' do
    context 'root pathにget request' do
      before { get root_path }

      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      it 'タイトルがアプリ名のみになること' do
        expect(response.body).to include 'DogrunConnect'
        expect(response.body).not_to include '| DogrunConnect'
      end
    end

    context 'private_policyにget request' do
      before { get privacy_policy_path }

      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      it 'タイトルが正常に表示さえれること' do
        expect(response.body).to include(I18n.t('defaults.privacy_policy'))
        expect(response.body).to include '| DogrunConnect'
      end
    end

    context 'terms_of_serviceにget request' do
      before { get terms_of_service_path }

      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      it 'タイトルが正常に表示さえれること' do
        expect(response.body).to include(I18n.t('defaults.terms_of_service'))
        expect(response.body).to include '| DogrunConnect'
      end
    end
  end

  describe '名前空間「犬のしつけ広場」' do
    context 'togo_inu_shitsuke_hiroba/static_pages#topにrequest' do
      before { get togo_inu_shitsuke_hiroba_top_path }

      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      it 'タイトルが正常に表示されていること' do
        expect(response.body).to include('犬のしつけ広場 | DogrunConnect')
      end
    end

    context 'togo_inu_shitsuke_hiroba/static_pages#compliance_confirmation request' do
      before { get togo_inu_shitsuke_hiroba_compliance_confirmations_path }

      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      it 'タイトルが正常に表示されていること' do
        expect(response.body).to include('利用上の遵守・確認事項 | 犬のしつけ広場 | DogrunConnect')
      end
    end
  end
end
