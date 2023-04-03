require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET #top' do
    let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
    let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
    let!(:user) { create(:user, :general) }
    let!(:dog) { create(:dog, :castrated, :public_view, user: user) }
    
    context '非ログイン時' do
      before { get root_path }

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      example 'タイトルがアプリ名のみになること' do
        expect(response.body).to include 'DogrunConnect'
      end

      example '@linkがセットされないこと' do
        expect(assigns(:link)).to be_nil
      end
    end

    describe 'ログイン時' do
      let!(:entry) { create(:entry, dog: dog, registration_number: create(:registration_number, dog: dog, dogrun_place: dogrun_place_1)) } 
      before do
        togo_inu_shitsuke_hiroba_log_in_as(user)
        get root_path
      end

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      example '前回入場したドッグランがセットされていること' do
        expect(assigns(:dogrun_place)).to eq(dogrun_place_1)
      end

      context '前回入場したドッグランが「犬のしつけ広場」の場合' do
        example 'sets @link to Togo Inu Shitsuke Hiroba top path' do
          expect(assigns(:link)).to eq(togo_inu_shitsuke_hiroba_top_path)
        end
      end

      context '前回入場したドッグランが「里音(Re:on)」の場合' do
        let!(:entry) { create(:entry, dog: dog, registration_number: create(:registration_number, dog: dog, dogrun_place: dogrun_place_2)) } 

        it 'sets @link to Reon top path' do
          expect(assigns(:link)).to eq(reon_top_path)
        end
      end
    end

  end

  describe 'GET #private_policy' do
    before { get privacy_policy_path }

    example 'レスポンスが正常なこと' do
      expect(response).to have_http_status(:success)
    end

    example 'タイトルが正常に表示されること' do
      expect(response.body).to include(I18n.t('defaults.privacy_policy'))
      expect(response.body).to include '| DogrunConnect'
    end
  end

  describe 'GET #terms_of_service' do
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
