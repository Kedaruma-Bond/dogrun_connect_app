require 'rails_helper'

RSpec.describe Admin::StaffsController, type: :request do
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:admin_1) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }
  let!(:staff_1) { create(:staff, dogrun_place: dogrun_place_1) } 
  let!(:staff_2) { create(:staff, dogrun_place: dogrun_place_2) } 

  describe 'GET #index' do
    describe '管理者ユーザーでログインしているとき' do
      before do
        admin_log_in_as(admin_1)
        get admin_staffs_path
      end

      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end

      example '管理ドッグランに紐づいたstaffが表示されていること' do
        expect(assigns(:staffs)).to eq([staff_1])
      end

      example '別のドッグランに紐づいたstaffは表示されないこと' do
        expect(assigns(:staffs)).not_to eq([staff_2])
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        get admin_staffs_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
        get admin_staffs_path
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get admin_staffs_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'POST #create' do
    let!(:valid_attributes) { attributes_for(:staff) }
    let!(:invalid_attributes) { attributes_for(:staff, name: '') }

    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '有効なパラメータが入力されている場合' do
        example '新規作成されること' do
          expect {
            post admin_staffs_path, params: { staff: valid_attributes }
          }.to change(Staff, :count).by(1)
          expect(flash[:success]).to eq(I18n.t('admin.staffs.create.staff_create'))
          expect(response).to redirect_to(admin_staffs_path)
        end
  
        example '登録メールが送信されること' do
          expect {
            post admin_staffs_path, params: { staff: valid_attributes }
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context '無効なパラメータが入力されている場合' do
        example '新規登録されないこと' do
          expect {
            post admin_staffs_path, params: { staff: invalid_attributes }
          }.not_to change(Staff, :count)
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:staff).errors).to be_of_kind(:name, :blank)
        end

        example '登録メールが送信されないこと' do
          expect {
            post admin_staffs_path, params: { staff: invalid_attributes }
          }.not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        post admin_staffs_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        post admin_staffs_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get new_admin_sns_account_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '管理ドッグランに紐づいたstaffを削除するとき' do
        example '削除できること' do
          expect {
            delete admin_staff_path(staff_1)
          }.to change(Staff, :count).by(-1)
          expect(response).to redirect_to(admin_staffs_path)
          expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
        end
      end

      context '別のドッグランに紐づいたstaffを削除するとき' do
        example '削除されずエラーメッセージが表示され管理者home画面にリダイレクトされること' do
          expect {
            delete admin_staff_path(staff_2)
          }.not_to change(Staff, :count)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect {
          delete admin_staff_path(staff_1)
        }.not_to change(Staff, :count)
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }
      example 'エラーメッセージが表示されhome画面にリダイレクトされること' do
        expect {
          delete admin_staff_path(staff_1)
        }.not_to change(Staff, :count)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        delete admin_staff_path(staff_1)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'PATCH #enable_notification' do
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '管理ドッグランに紐づいたstaffを更新するとき' do
        example '更新できること' do
          patch enable_notification_admin_staff_path(staff_1)
          expect(staff_1.reload.enable_notification).to eq("enable")
          expect(response).to redirect_to(admin_staffs_path)
          expect(flash[:success]).to eq(I18n.t('admin.staffs.enable_notification.change_to_enable'))
        end
      end

      context '別のドッグランに紐づいたstaffを更新するとき' do
        example '更新できないこと' do
          patch enable_notification_admin_staff_path(staff_2)
          expect(staff_2.reload.enable_notification).to eq("disable")
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        patch enable_notification_admin_staff_path(staff_1)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }
      example 'エラーメッセージが表示されhome画面にリダイレクトされること' do
        patch enable_notification_admin_staff_path(staff_1)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        patch enable_notification_admin_staff_path(staff_1)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'PATCH #disable_notification' do
    let!(:staff_3) { create(:staff, dogrun_place: dogrun_place_1, enable_notification: "enable") }
    let!(:staff_4) { create(:staff, dogrun_place: dogrun_place_2, enable_notification: "enable") }
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '管理ドッグランに紐づいたstaffを更新するとき' do
        example '更新できること' do
          patch disable_notification_admin_staff_path(staff_3)
          expect(staff_3.reload.enable_notification).to eq("disable")
          expect(response).to redirect_to(admin_staffs_path)
          expect(flash[:success]).to eq(I18n.t('admin.staffs.disable_notification.change_to_disable'))
        end
      end

      context '別のドッグランに紐づいたstaffを更新するとき' do
        example '更新できないこと' do
          patch disable_notification_admin_staff_path(staff_4)
          expect(staff_4.reload.enable_notification).to eq("enable")
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        patch disable_notification_admin_staff_path(staff_3)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) }
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        patch disable_notification_admin_staff_path(staff_3)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        patch disable_notification_admin_staff_path(staff_3)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
