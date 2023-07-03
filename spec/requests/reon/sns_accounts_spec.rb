require 'rails_helper'

RSpec.describe Reon::SnsAccountsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }
  let!(:other) { create(:user, :general) }
  let!(:sns_accounts_1) { create(:sns_account, user: general) }
  let!(:sns_accounts_2) { create(:sns_account, user: other) }
  let!(:guest) { create(:user, :guest) }

  describe 'GET #new' do
    context 'ログインしている時' do
      before do
        reon_log_in_as(general)
      end

      example '正常にレスポンスがかえること' do
        get new_reon_sns_account_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end
    
    describe 'ゲストログインしているとき' do
      before do
        reon_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get new_reon_sns_account_path
        expect(response).to redirect_to(reon_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    context 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get new_reon_sns_account_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user, :general) }

    describe 'ログインしている時' do
      before do
        reon_log_in_as(user)
      end
      
      context 'すでにsns_accountが登録済の場合' do
        let!(:sns_accounts_3) { create(:sns_account, user: user) }
        let(:valid_params) { attributes_for(:sns_account, user: user) }
        example '新規作成されないこと' do
          expect { 
            post reon_sns_accounts_path, params: { sns_account: valid_params }
          }.not_to change(SnsAccount, :count)
          expect(response).to redirect_to(reon_user_path(user))
          expect(flash[:error]).to eq(I18n.t('local.sns_accounts.registration_duplicated'))
        end
      end
      
      context '有効なパラメータが入力されている場合' do
        let!(:valid_params) { attributes_for(:sns_account, user: user) }
        example '新規作成されること' do
          expect {
            post reon_sns_accounts_path,
            params: {
              sns_account: valid_params
            }
          }.to change(SnsAccount, :count).by(1)
          expect(response).to redirect_to(reon_user_path(user))
          expect(flash[:success]).to eq(I18n.t('local.sns_accounts.registration_successful'))
        end
      end

      context '無効なパラメータが入力されている場合' do
        let!(:invalid_params) { attributes_for(:sns_account, twitter_id: "", instagram_id: "", facebook_id: "", user: user)}
        example '新規登録されないこと' do
          expect {
            post reon_sns_accounts_path,
            params: {
              sns_account: invalid_params
            }
          }.not_to change(SnsAccount, :count)
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:sns_account).errors).to be_of_kind(:base, I18n.t('defaults.input_any_one_sns_account'))
        end
      end
    end
    
    describe 'ゲストログインしているとき' do
      before do
        reon_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        post reon_sns_accounts_path
        expect(response).to redirect_to(reon_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post reon_sns_accounts_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #edit' do
    describe 'ログインしている時' do
      before do
        reon_log_in_as(general)
      end

      context 'ログインしているアカウントに紐づいたdataをeditする場合' do
        example '正常にレスポンスがかえること' do
          get edit_reon_sns_account_path(sns_accounts_1)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
          expect(assigns(:sns_account)).to eq(sns_accounts_1)
        end
      end

      context '別のアカウントに紐づいたdataをeditする場合' do
        example '表示されないこと' do
          get edit_reon_sns_account_path(sns_accounts_2)
          expect(response).to redirect_to(reon_user_path(general))
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end
    
    context 'ゲストログインしているとき' do
      before do
        reon_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get edit_reon_sns_account_path(sns_accounts_1)
        expect(response).to redirect_to(reon_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    context 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get edit_reon_sns_account_path(sns_accounts_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'PATCH #update' do
    describe 'ログインしている時' do
      before do
        reon_log_in_as(general)
      end

      context 'ログイン中のアカウントと紐づいたdataを更新する場合' do
        example '更新できること' do
          patch reon_sns_account_path(sns_accounts_1),
            params: {
              sns_account: {
                twitter_id: ""
              }
            }
          expect(sns_accounts_1.reload.twitter_id).to eq("")
          expect(response).to redirect_to(reon_user_path(general))
          expect(flash[:success]).to eq(I18n.t('defaults.update_successfully'))
        end
      end

      context '別のアカウントに紐づいたdataを更新する場合' do
        example '更新できないこと' do
          patch reon_sns_account_path(sns_accounts_2),
            params: {
              sns_account: {
                twitter_id: ""
              }
            }
          expect(sns_accounts_2.reload.twitter_id).not_to eq("")
          expect(response).to redirect_to(reon_user_path(general))
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end
    
    describe 'ゲストログインしているとき' do
      before do
        reon_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        patch reon_sns_account_path(sns_accounts_1)
        expect(response).to redirect_to(reon_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        patch reon_sns_account_path(sns_accounts_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'ログインしている時' do
      before do
        reon_log_in_as(general)
      end

      context 'ログインしているアカウントに紐づいたdataを削除する場合' do
        example '削除できること' do
          expect {
            delete reon_sns_account_path(sns_accounts_1)
          }.to change(SnsAccount, :count).by(-1)
          expect(response).to redirect_to(reon_user_path(general))
          expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
        end
      end

      context '別のアカウントに紐づいているdataを削除する時' do
        example '削除できないこと' do
          expect {
            delete reon_sns_account_path(sns_accounts_2)
          }.not_to change(SnsAccount, :count)
          expect(response).to redirect_to(reon_user_path(general))
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end

    describe 'ゲストログインしている時' do
      before do
        reon_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        delete reon_sns_account_path(sns_accounts_1)
        expect(response).to redirect_to(reon_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end

    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        delete reon_sns_account_path(sns_accounts_1)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end

  end
end
