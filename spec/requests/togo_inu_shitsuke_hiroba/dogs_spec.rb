require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::DogsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:dog) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number) { create(:registration_number, dog: dog, dogrun_place: dogrun_place)}

  describe 'GET #show' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get togo_inu_shitsuke_hiroba_dog_path(dog)
        expect(response).to be_successful
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_path(dog)
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

      example '正常なレスポンスがかえること' do
        get edit_togo_inu_shitsuke_hiroba_dog_path(dog)
        expect(response).to be_successful
      end
    end
    
    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get edit_togo_inu_shitsuke_hiroba_dog_path(dog)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) { { dog: { name: 'Updated Dog' } } }

    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      context '有効なパラメータが入力されている場合' do
        example '更新されること' do
          patch togo_inu_shitsuke_hiroba_dog_path(dog), params: valid_params
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_dog_path(dog))
          dog.reload
          expect(dog.name).to eq('Updated Dog')
        end
      end
  
      context '無効なパラメータが入力されている場合' do
        it '更新されずedit formが表示されること' do
          patch togo_inu_shitsuke_hiroba_dog_path(dog), params: { dog: { name: '' } }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
          expect(assigns(:dog).errors).to be_of_kind(:name, :blank)
        end
      end
    end
    
    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        patch togo_inu_shitsuke_hiroba_dog_path(dog)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
