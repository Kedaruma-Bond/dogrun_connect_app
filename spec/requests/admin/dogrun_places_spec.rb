require 'rails_helper'

RSpec.describe Admin::DogrunPlacesController, type: :request do
  let!(:grand_admin_dogrun_place) { create(:dogrun_place, :grand_admin) }
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:grand_admin) { create(:user, :grand_admin, dogrun_place: :grand_admin) }
  let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }

  describe 'GET #index' do
    describe '管理者ユーザーでとログインしている場合' do
      before do
        admin_log_in_as(admin)
      end
    end

    example '正常なレスポンスが返ること' do
      get admin_dogrun_places_path
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:dogrun_place) { FactoryBot.create(:dogrun_place) }

    it 'returns a successful response' do
      get admin_dogrun_place_path(dogrun_place)
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get new_admin_dogrun_place_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { dogrun_place: FactoryBot.attributes_for(:dogrun_place) } }

    context 'with valid parameters' do
      it 'creates a new dogrun_place' do
        expect {
          post admin_dogrun_places_path, params: valid_params
        }.to change(DogrunPlace, :count).by(1)
      end

      it 'redirects to the dogrun_places index' do
        post admin_dogrun_places_path, params: valid_params
        expect(response).to redirect_to(admin_dogrun_places_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { dogrun_place: { name: nil } } }

      it 'does not create a new dogrun_place' do
        expect {
          post admin_dogrun_places_path, params: invalid_params
        }.to_not change(DogrunPlace, :count)
      end

      it 'renders the new template with an error status' do
        post admin_dogrun_places_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    let(:dogrun_place) { FactoryBot.create(:dogrun_place) }

    it 'returns a successful response' do
      get edit_admin_dogrun_place_path(dogrun_place)
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    let(:dogrun_place) { FactoryBot.create(:dogrun_place) }
    let(:valid_params) { { dogrun_place: { name: 'New name' } } }

    context 'with valid parameters' do
      it 'updates the requested dogrun_place' do
        patch admin_dogrun_place_path(dogrun_place), params: valid_params
        expect(dogrun_place.reload.name).to eq('New name')
      end

      it 'redirects to the dogrun_place' do
        patch admin_dogrun_place_path(dogrun_place), params: valid_params
        expect(response).to redirect_to(admin_dogrun_place_path(dogrun_place))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { dogrun_place: { name: nil } } }

      it 'does not update the dogrun_place' do
        expect {
          patch admin_dogrun_place_path(dogrun_place), params: invalid_params
        }.to_not change { dogrun_place.reload.name }
      end

      it 'renders the edit template with an error status
