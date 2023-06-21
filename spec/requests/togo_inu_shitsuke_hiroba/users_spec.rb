require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::UsersController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }

  describe 'GET #route_selection' do
    before do
      get togo_inu_shitsuke_hiroba_route_selection_path
    end
    example 'レスポンスが正常なこと' do
      expect(response).to have_http_status(:success) 
    end
  end
  
  describe 'GET #fully_route' do
    before do
      get togo_inu_shitsuke_hiroba_fully_route_path
    end
    example 'レスポンスが正常なこと' do
      session[:fully_flg] = true
      expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path) 
    end
  end
  
  describe 'GET #minimum_route' do
    before do
      get togo_inu_shitsuke_hiroba_minimum_route_path
    end
    example 'レスポンスが正常なこと' do
      session[:fully_flg] = false
      expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path) 
    end
  end
  
  describe 'GET #new' do
    before do
      get togo_inu_shitsuke_hiroba_signup_path
    end
    example 'レスポンスが正常なこと' do
      expect(response).to have_http_status(:success) 
    end
  end

  describe 'POST #create' do
    let!(:valid_attributes) { attributes_for(:user, :general, dogrun_place_id: nil)}
    let!(:invalid_attributes) { attributes_for(:user, :general, name: "", dogrun_place_id: nil)}
    
    context '入力値が正しい場合' do
      example '新規登録できること' do
        expect {
          post togo_inu_shitsuke_hiroba_users_path, params: {
            user: valid_attributes
          }
        }.to change(User, :count).by(1)
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_dog_registration_path)
        expect(flash[:success]).to eq(I18n.t("local.users.user_create"))
        # ログインできていることの検証
        get togo_inu_shitsuke_hiroba_top_path
        expect(response.body).to include(valid_attributes[:name])
        expect(response.body).to include(I18n.t('shared.login_top_content.please_register_dog'))
      end
    end

    context '不正な入力値の場合' do
      example '新規作成されないこと' do
        expect {
          post togo_inu_shitsuke_hiroba_users_path, params: {
            user: invalid_attributes
          }
        }.not_to change(User, :count)
        expect(response).to render_template(:new)
      end
    end
  end
end
