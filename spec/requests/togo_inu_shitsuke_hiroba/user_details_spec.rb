require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::UserDetailsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:other) { create(:user, :general) }
  let!(:user_detail_1) { create(:user_detail, user: general) }
  let!(:user_detail_2) { create(:user_detail, user: other) }
  let!(:guest) { create(:user, :guest) }

  describe 'GET #new' do
    context 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正常にレスポンスがかえること' do
        get new_togo_inu_shitsuke_hiroba_user_detail_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end
    
    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get new_togo_inu_shitsuke_hiroba_user_detail_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    context 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get new_togo_inu_shitsuke_hiroba_user_detail_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #signup_fully_route' do
    context 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正常にレスポンスがかえること' do
        get signup_fully_route_togo_inu_shitsuke_hiroba_user_details_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:signup_fully_route)
      end
    end
    
    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get signup_fully_route_togo_inu_shitsuke_hiroba_user_details_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    context 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get signup_fully_route_togo_inu_shitsuke_hiroba_user_details_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user, :general) }
    let!(:valid_params) { attributes_for(:user_detail, user: user) }
    let!(:invalid_params) { attributes_for(:user_detail, zip_code: "", user: user)}

    describe 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(user)
      end

      describe 'すでにuser_detailが登録済の場合' do
        let!(:user_detail_3) { create(:user_detail, user: user) }
        example '新規作成されないこと' do
          expect { 
            post togo_inu_shitsuke_hiroba_user_details_path, params: { user_detail: valid_params }
          }.not_to change(UserDetail, :count)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(user))
          expect(flash[:error]).to eq(I18n.t('local.user_details.registration_duplicated'))
        end
      end
      
      describe '有効なパラメータが入力されている時' do
        example '新規作成されること' do
          expect {
            post togo_inu_shitsuke_hiroba_user_details_path,
            params: {
              user_detail: valid_params
            }
          }.to change(UserDetail, :count).by(1)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(user))
          expect(flash[:success]).to eq(I18n.t('local.user_details.created_successfully'))
        end
      end
  
      describe '無効なパラメータが入力されている時' do
        example '新規登録されないこと' do
          expect {
            post togo_inu_shitsuke_hiroba_user_details_path,
            params: {
              user_detail: invalid_params
            }
          }.not_to change(SnsAccount, :count)
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:user_detail).errors).to be_of_kind(:zip_code, :blank)
        end
      end 
    end
    
    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_user_details_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_user_details_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #edit' do
    describe 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      context 'ログインしているアカウントに紐づいたdataをeditする場合' do
        example '正常にレスポンスがかえること' do
          get edit_togo_inu_shitsuke_hiroba_user_detail_path(user_detail_1)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
          expect(assigns(:user_detail)).to eq(user_detail_1)
        end
      end

      context '別のアカウントに紐づいたdataをeditする場合' do
        example '表示されないこと' do
          get edit_togo_inu_shitsuke_hiroba_user_detail_path(user_detail_2)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(general))
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end
    
    context 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get edit_togo_inu_shitsuke_hiroba_sns_account_path(user_detail_1)
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    context 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get edit_togo_inu_shitsuke_hiroba_sns_account_path(user_detail_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'PATCH #update' do
    describe 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      describe 'ログイン中のアカウントと紐づいたdataを更新する場合' do
        context '入力値が正しいとき' do
          example '更新できること' do
            patch togo_inu_shitsuke_hiroba_user_detail_path(user_detail_1),
              params: {
                user_detail: {
                  zip_code: "777-7777"
                }
              }
            expect(user_detail_1.reload.zip_code).to eq("777-7777")
            expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(general))
            expect(flash[:success]).to eq(I18n.t('defaults.update_successfully'))
          end
        end

        context '入力値が不正なとき' do
          example '更新できないこと' do
            patch togo_inu_shitsuke_hiroba_user_detail_path(user_detail_1),
            params: {
              user_detail: {
                zip_code: ""
              }
            }
            expect(user_detail_1.reload.zip_code).not_to eq("")
            expect(response).to render_template(:edit)
            expect(assigns(:user_detail).errors).to be_of_kind(:zip_code, :blank)
          end
        end
      end

      context '別のアカウントに紐づいたdataを更新する場合' do
        example '更新できないこと' do
          patch togo_inu_shitsuke_hiroba_user_detail_path(user_detail_2),
            params: {
              user_detail: {
                zip_code: "777-7777"
              }
            }
          expect(user_detail_2.reload.zip_code).not_to eq("777-7777")
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(general))
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end
    
    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        patch togo_inu_shitsuke_hiroba_user_detail_path(user_detail_1)
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        patch togo_inu_shitsuke_hiroba_user_detail_path(user_detail_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      context 'ログインしているアカウントに紐づいたdataを削除する場合' do
        example '削除できること' do
          expect {
            delete togo_inu_shitsuke_hiroba_user_detail_path(user_detail_1)
          }.to change(UserDetail, :count).by(-1)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(general))
          expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
        end
      end

      context '別のアカウントに紐づいているdataを削除する時' do
        example '削除できないこと' do
          expect {
            delete togo_inu_shitsuke_hiroba_user_detail_path(user_detail_2)
          }.not_to change(SnsAccount, :count)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(general))
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end

    describe 'ゲストログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        delete togo_inu_shitsuke_hiroba_user_detail_path(user_detail_1)
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end

    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        delete togo_inu_shitsuke_hiroba_user_detail_path(user_detail_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
