require 'rails_helper'

RSpec.describe Admin::SnsAccountsController, type: :request do
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:admin_1) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }
  
  describe 'GET #new' do
    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      example '正常なレスポンスが返ること' do
        get new_admin_sns_account_path
        expect(response).to have_http_status(:success)
      end
    end

    context '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        get new_admin_sns_account_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get new_admin_sns_account_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'POST #create' do
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }

      context '有効なパラメータが入力されている場合' do
        let(:valid_params) { attributes_for(:sns_account) }
        example 'sns_accountが新規作成されメッセージが表示されてドッグランの詳細画面にリダイレクトすること' do
          expect { 
            post admin_sns_accounts_path, params: { sns_account: valid_params }
          }.to change(SnsAccount, :count).by(1)
          expect(response).to redirect_to(admin_dogrun_place_path(admin_1.dogrun_place))
          expect(flash[:success]).to eq(I18n.t('local.sns_accounts.registration_successful'))
        end
      end

      context '無効なパラメータが入力されている場合' do
        let(:invalid_params) { attributes_for(:sns_account, twitter_id: "", instagram_id: "", facebook_id: "") }
        example '新規作成されないこと' do
          expect { 
            post admin_sns_accounts_path, params: { sns_account: invalid_params }
          }.not_to change(SnsAccount, :count)
          expect(response).to render_template(:new)
        end
      end

      context 'すでにsns_accountが登録済の場合' do
        let!(:sns_accounts_1) { create(:sns_account, dogrun_place: dogrun_place_1) }
        let(:valid_params) { attributes_for(:sns_account) }
        example '新規作成されないこと' do
          expect { 
            post admin_sns_accounts_path, params: { sns_account: valid_params }
          }.not_to change(SnsAccount, :count)
          expect(response).to redirect_to(admin_dogrun_place_path(admin_1.dogrun_place))
          expect(flash[:error]).to eq(I18n.t('local.sns_accounts.registration_duplicated'))
        end
      end
    end

    describe '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        post admin_sns_accounts_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        post admin_sns_accounts_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'GET #edit' do
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '管理ドッグランに紐づいたsns_accountを編集する場合' do
        let!(:sns_accounts_1) { create(:sns_account, dogrun_place: dogrun_place_1) }
        example '正常なレスポンスが返ること' do
          get edit_admin_sns_account_path(sns_accounts_1)
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
          expect(assigns(:sns_account)).to eq(sns_accounts_1)
        end
      end

      context '別のドッグランに紐づいたsns_accountを編集する場合' do
        let!(:sns_accounts_2) { create(:sns_account, dogrun_place: dogrun_place_2) }
        example 'エラーメッセージが表示されること' do
          get edit_admin_sns_account_path(sns_accounts_2)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:sns_accounts_1) { create(:sns_account, dogrun_place: dogrun_place_1) }
    let!(:sns_accounts_2) { create(:sns_account, dogrun_place: dogrun_place_2) }
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '管理ドッグランに紐づいたsns_accountを更新する場合' do
        before do
          patch admin_sns_account_path(sns_accounts_1),
            params: {
            sns_account: {
              twitter_id: ""
            }
          }
        end
        example '更新されメッセージが表示されてドッグランの詳細画面にリダイレクトされること' do
          expect(sns_accounts_1.reload.twitter_id).to eq("")
          expect(response).to redirect_to(admin_dogrun_place_path(admin_1.dogrun_place))
          expect(flash[:success]).to eq(I18n.t('defaults.update_successfully'))
        end
      end

      context '別のドッグランに紐づいたsns_sccountを更新する場合' do
        example 'ホーム画面にリダイレクトされエラーメッセージが表示されること' do
          patch admin_sns_account_path(sns_accounts_2)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
        patch admin_sns_account_path(sns_accounts_1) 
      end

      example 'エラーメッセージが表示されてroot_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      before do
        patch admin_sns_account_path(sns_accounts_1) 
      end

      example 'エラーメッセージが表示されadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:sns_accounts_1) { create(:sns_account, dogrun_place: dogrun_place_1) }
    let!(:sns_accounts_2) { create(:sns_account, dogrun_place: dogrun_place_2) }
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '管理ドッグランに紐づいたsns_accountを削除する場合' do
        example '削除できること' do
          expect {
            delete admin_sns_account_path(sns_accounts_1)
          }.to change(SnsAccount, :count).by(-1)
          expect(response).to redirect_to(admin_dogrun_place_path(admin_1.dogrun_place))
          expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
        end
      end

      context '別のドッグランに紐づいたsns_accountを削除する場合' do
        example '削除できないこと' do
          expect {
            delete admin_sns_account_path(sns_accounts_2)
          }.not_to change(SnsAccount, :count)
          expect(response).to redirect_to(admin_root_path)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end

    describe '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect {
          delete admin_sns_account_path(sns_accounts_1)
        }.not_to change(SnsAccount, :count)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていなとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        expect {
          delete admin_sns_account_path(sns_accounts_1)
        }.not_to change(SnsAccount, :count)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
