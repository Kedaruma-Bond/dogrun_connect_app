require 'rails_helper'

RSpec.describe Admin::SessionsController, type: :request do
  describe 'GET #new' do
    example '正常なレスポンスが返ること' do
      get admin_login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:admin) { create(:user, :admin) }

    context '有効なパラメータが入力された場合' do
      example 'ログインしてメッセージが表示され管理者home画面にリダイレクトすること' do
        post admin_login_path, params: { 
          session: {
            email: admin.email,
            password: "password"
          }
        }
        expect(is_logged_in?).to eq(true)
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:success]).to eq(I18n.t('admin.sessions.create.admin_login'))
      end
    end

    context '無効なパラメータが入力された場合' do
      example 'エラーメッセージが表示されnewテンプレートがレンダリングされること' do
        post admin_login_path, params: { 
          session: {
            email: admin.email,
            password: ""
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        expect(flash[:error]).to eq(I18n.t('admin.sessions.create.login_fail'))
      end
    end

    context '凍結されたアカウントでログインを試みる場合' do
      before do
        admin.update(deactivation: 'account_frozen')
      end

      example 'ログインできずエラーメッセージが表示されること' do
        post admin_login_path, params: { 
          session: {
            email: admin.email,
            password: "password"
          }
        }
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('admin.sessions.create.login_fail'))
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    
  end

  describe 'DELETE #destroy' do
    let(:admin) { create(:user, :admin) }
    context '管理者ログインしているとき' do
      before { admin_log_in_as(admin) }
      
      example 'メッセージが表示されてログアウトし管理者ログイン画面にリダイレクトされること' do
        delete admin_logout_path
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to('/admin/login')
        expect(flash[:success]).to eq(I18n.t('admin.sessions.destroy.logout'))
      end
    end
  end
end
