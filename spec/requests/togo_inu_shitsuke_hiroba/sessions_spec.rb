require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::SessionsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }

  describe 'GET #new' do
    example '正常なレスポンスが返されること' do
      get togo_inu_shitsuke_hiroba_login_path
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context '正しいパラメータが渡された場合' do
      example 'ログインし、リダイレクトされること' do
        post togo_inu_shitsuke_hiroba_login_path, params: { session: { email: general.email, password: 'password' } }
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
        expect(flash[:success]).to eq(I18n.t('local.sessions.login_successfully'))
      end
    end

    context '無効なパラメータが渡された場合' do
      example 'ログインが失敗し、エラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_login_path, params: { session: { email: general.email, password: 'invalid' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:error]).to eq(I18n.t('local.sessions.login_failed'))
        expect(response).to render_template(:new)
      end
    end

    context '規定回数(10回)ログインに失敗した場合' do
      before do
        10.times do
          post togo_inu_shitsuke_hiroba_login_path, params: { session: { email: general.email, password: 'invalid' } }
        end
      end

      example 'ログイン機能が一時的にロックされること' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:error]).to eq(I18n.t('local.sessions.account_locked'))
        expect(general.reload.lock_expires_at).to be_within(1.second).of(5.minutes.from_now)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      togo_inu_shitsuke_hiroba_log_in_as(general)
    end

    example 'ユーザーがログアウトし、リダイレクトされること' do
      delete togo_inu_shitsuke_hiroba_logout_path
      expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
      expect(flash[:notice]).to eq(I18n.t('local.sessions.logout'))
    end
  end

  describe 'POST #guest_login' do
    example 'ゲストユーザーとしてログインし、リダイレクトされること' do
      expect {
        post togo_inu_shitsuke_hiroba_guest_login_path
      }.to change(User, :count).by(1)
      expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
      expect(flash[:success]).to eq(I18n.t('local.sessions.guest_login_successfully'))
      # redirectされているだけではrequest spec上は画面がgetされていないので
      # 一度getで画面をrequestしてあげるべし
      get togo_inu_shitsuke_hiroba_top_path
      expect(response.body).to include(I18n.t('local.static_pages.top.jump_to_signup'))
      expect(response.body).to include('GUEST')
    end
  end

  describe 'GET #jump_to_signup' do
    let!(:guest) { create(:user, :guest) }

    context '現在のユーザーがゲストユーザーの場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end

      example 'ログアウトし、リダイレクトされること' do
        post togo_inu_shitsuke_hiroba_jump_to_signup_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_route_selection_path)
        expect(flash[:notice]).to eq(I18n.t('local.sessions.signup_please'))
        get togo_inu_shitsuke_hiroba_top_path
        expect(response.body).not_to include(I18n.t('local.static_pages.top.jump_to_signup'))
        expect(response.body).not_to include('GUEST')
      end
    end

    context '現在のユーザーがゲストユーザーでない場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'リダイレクトされないこと' do
        post togo_inu_shitsuke_hiroba_jump_to_signup_path
        expect(response).not_to redirect_to(togo_inu_shitsuke_hiroba_route_selection_path)
        get togo_inu_shitsuke_hiroba_top_path
        expect(response.body).to include(general.name)
      end
    end
  end
end
