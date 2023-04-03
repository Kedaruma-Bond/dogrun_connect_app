require 'rails_helper'

RSpec.describe 'TogoInuShitsukeHiroba::StaticPages', type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:user) { create(:user, :general) }
  let!(:dog) { create(:dog, user: user) }
  let!(:entry) { create(:entry, dog: dog, registration_number: create(:registration_number, dogrun_place: dogrun_place)) } 

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
