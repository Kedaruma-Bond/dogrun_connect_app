require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  let!(:grand_admin_place) { create(:dogrun_place, :grand_admin_place) }
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:grand_admin) { create(:user, :grand_admin, dogrun_place: grand_admin_place) }
  let!(:admin_1) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }

  describe "GET #index" do
    context 'grand_adminでログインしているとき' do
      before { admin_log_in_as(grand_admin) }

      example "正常なレスポンスが返ること" do
        get admin_users_path
        expect(response).to have_http_status(:success)
      end
    end

    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }

      example 'エラーメッセージが表示され管理home画面がにリダイレクトされること' do
        get admin_users_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        get admin_users_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        get admin_users_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'エラーメッセージが表示され管理home画面がにリダイレクトされること' do
        get admin_users_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe "GET #new" do
    context 'grand_adminでログインしているとき' do
      before { admin_log_in_as(grand_admin) }

      example "正常なレスポンスが返ること" do
        get new_admin_user_path
        expect(response).to have_http_status(:success)
      end
    end

    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }

      example 'エラーメッセージが表示され管理home画面がにリダイレクトされること' do
        get new_admin_user_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        get new_admin_user_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        get new_admin_user_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get new_admin_user_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe "POST #create" do
    let!(:valid_attributes) { attributes_for(:user, :admin_user, dogrun_place_id: dogrun_place_1.id) }
    let!(:invalid_attributes) { attributes_for(:user, :admin_user, name: "") }

    describe 'grand_adminでログインしているとき' do
      before do 
        admin_log_in_as(grand_admin) 
      end
      context '有効なパラメータが入力されている場合' do
        example '新規登録されること' do
          expect {
            post admin_users_path, params: {
              user: valid_attributes
            }
          }.to change(User, :count).by(1)
          expect(response).to redirect_to(admin_users_path)
          expect(flash[:success]).to eq(I18n.t("admin.users.create.admin_user_create"))
        end

        example '登録メールが送信されること' do
          expect {
            post admin_users_path, params: {
              user: valid_attributes
            }
          }.to change { ActionMailer::Base.deliveries.count}.by(1)
        end
      end

      context "無効なパラメータが入力されているとき" do
        example "新規登録されないこと" do
          expect {
            post admin_users_path, params: {
              user: invalid_attributes
            }
          }.not_to change(User, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end
      end
    end

    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      
      example 'エラーメッセージが表示され管理home画面がにリダイレクトされること' do
        post admin_users_path 
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        post admin_users_path 
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        post admin_users_path 
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        post admin_users_path 
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe "DELETE #destroy" do

    context 'grand_adminでログインしているとき' do
      before { admin_log_in_as(grand_admin) }
      example "削除できること" do
        expect {
          delete admin_user_path(general)
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
      end
    end

    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      
      example 'エラーメッセージが表示され管理home画面がにリダイレクトされること' do
        delete admin_user_path(general)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        delete admin_user_path(general)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        delete admin_user_path(general)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        delete admin_user_path(general) 
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'GET #search' do
    context 'grand_adminでログインしているとき' do
      before { admin_log_in_as(grand_admin) }

      example "正常なレスポンスがかえること" do
        get search_admin_users_path
        expect(response).to have_http_status(:success)
      end
    end

    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      
      example 'エラーメッセージが表示され管理home画面がにリダイレクトされること' do
        get search_admin_users_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
    
    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        get search_admin_users_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        get search_admin_users_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
      
    end
    
    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get search_admin_users_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe "PATCH #deactivation" do
    let!(:not_BAN_user) { create(:user, :general) }
    context 'grand_adminでログインしているとき' do
      before { admin_log_in_as(grand_admin) }
      
      example "該当userをBAN状態にできること" do
        patch deactivation_admin_user_path(not_BAN_user)
        expect(not_BAN_user.reload.deactivation).to eq("account_frozen")
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      
      example 'エラーメッセージが表示され管理home画面がにリダイレクトされること' do
        patch deactivation_admin_user_path(not_BAN_user)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        patch deactivation_admin_user_path(not_BAN_user)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        patch deactivation_admin_user_path(not_BAN_user)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        patch deactivation_admin_user_path(not_BAN_user)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
  
  describe "PATCH #activation" do
    let!(:user_BAN) { create(:user, :general, :account_BAN) }
    context 'grand_adminでログインしているとき' do
      before { admin_log_in_as(grand_admin) }

      example 'アカウントBANが解除されること' do
        patch activation_admin_user_path(user_BAN)
        expect(user_BAN.reload.deactivation).to eq("account_activated")
        expect(response).to redirect_to(admin_users_path)
      end
    end
    
    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      
      example 'エラーメッセージが表示され管理home画面がにリダイレクトされること' do
        patch activation_admin_user_path(user_BAN)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        patch activation_admin_user_path(user_BAN)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        patch activation_admin_user_path(user_BAN)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        patch activation_admin_user_path(user_BAN)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
