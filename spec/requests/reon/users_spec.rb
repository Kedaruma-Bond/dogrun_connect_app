require 'rails_helper'

RSpec.describe Reon::UsersController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }

  describe 'GET #route_selection' do
    before do
      get reon_route_selection_path
    end
    example 'レスポンスが正常なこと' do
      expect(response).to have_http_status(:success) 
    end
  end
  
  describe 'GET #fully_route' do
    before do
      get reon_fully_route_path
    end
    example 'レスポンスが正常なこと' do
      expect(session[:fully_flg]).to be true
      expect(response).to redirect_to(reon_signup_path) 
    end
  end
  
  describe 'GET #minimum_route' do
    before do
      get reon_minimum_route_path
    end
    example 'レスポンスが正常なこと' do
      expect(session[:fully_flg]).to be false
      expect(response).to redirect_to(reon_signup_path) 
    end
  end
  
  describe 'GET #new' do
    before do
      get reon_signup_path
    end
    example 'レスポンスが正常なこと' do
      expect(response).to have_http_status(:success) 
    end
  end

  describe 'POST #create' do
    let!(:valid_attributes) { attributes_for(:user, :general, dogrun_place_id: nil)}
    let!(:invalid_attributes) { attributes_for(:user, :general, name: "", dogrun_place_id: nil)}
    
    context '入力値が正しい場合' do
      example '登録完了メールが送信されること' do
        expect {
          post reon_users_path, params: {
            user: valid_attributes
          }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      example 'ログインすること' do
        post reon_users_path, params: {
          user: valid_attributes
        }
        get reon_top_path
        expect(response.body).to include(valid_attributes[:name])
        expect(response.body).to include(I18n.t('shared.login_top_content.please_register_dog'))
      end

      example '新規登録できること' do
        expect {
          post reon_users_path, params: {
            user: valid_attributes
          }
        }.to change(User, :count).by(1)
        expect(response).to redirect_to(reon_dog_registration_path)
        expect(flash[:success]).to eq(I18n.t("local.users.user_create"))
      end
    end

    context '不正な入力値の場合' do
      example '新規作成されないこと' do
        expect {
          post reon_users_path, params: {
            user: invalid_attributes
          }
        }.not_to change(User, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user, :general)}
    let!(:dog) { create(:dog, :castrated, :public_view, user: general) }
    let!(:registration_number) { create(:registration_number, dog: dog, dogrun_place: dogrun_place)}

    describe 'ログインしている場合' do
      before do
        reon_log_in_as(general)
      end

      context 'ログインしているuserの画面を開くとき' do
        example '正常なレスポンスがかえること' do
          get reon_user_path(general)
          expect(response).to have_http_status(:success)
          expect(response.body).to include(dog.name)
          expect(response.body).to include(registration_number.registration_number)
        end
      end

      context '別のアカウントの画面を開くとき' do
        example '開けないこと' do
          get reon_user_path(user)
          expect(response).to redirect_to(root_path)
          expect(flash[:error]).to eq(I18n.t("defaults.require_correct_account"))
        end
      end
    end

    describe 'ログインしていない場合' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get reon_user_path(general)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
