require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::DogRegistrationController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:guest) { create(:user, :guest) }

  describe 'GET #form_selection' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正しくレンダリングされること' do
        get togo_inu_shitsuke_hiroba_dog_registration_form_selection_path
        expect(response).to render_template(:form_selection)
        expect(assigns(:confirmation)).to eq(I18n.t('local.dog_registrations.form_selection.confirmation', registration_card: I18n.t('togo_inu_shitsuke_hiroba.registration_card')))
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_dog_registration_form_selection_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_registration_form_selection_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_registration_form_selection_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #have_registration_card' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'card_flgがtrueに設定されnewリダイレクトされること' do
        get togo_inu_shitsuke_hiroba_dog_registration_have_registration_card_path
        expect(session[:card_flg]).to be true
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_dog_registration_path)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_dog_registration_have_registration_card_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_registration_have_registration_card_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_registration_have_registration_card_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #not_have_registration_card' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'card_flgがfalseに設定されnewリダイレクトされること' do
        get togo_inu_shitsuke_hiroba_dog_registration_not_have_registration_card_path
        expect(session[:card_flg]).to be false
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_dog_registration_path)
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_dog_registration_not_have_registration_card_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_registration_not_have_registration_card_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_registration_not_have_registration_card_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #new' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get togo_inu_shitsuke_hiroba_dog_registration_path
        expect(response).to render_template(:new)
        expect(assigns(:registration_number_hint)).to eq(I18n.t('local.dog_registrations.new.registration_number_hint', registration_card: I18n.t('togo_inu_shitsuke_hiroba.registration_card')))
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_dog_registration_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_registration_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_registration_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'POST #create' do
    let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place) }
    
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      context '正しいパラメータが入力されている場合' do
        example 'DogとRegistrationNumberが作成されること' do
          expect {
            post togo_inu_shitsuke_hiroba_dog_registration_path,
            params: {
              dog_registration: {
                name: "bond",
                castration: "castrated",
                public: "public_view",
                user_id: general.id,
                registration_number: "12345",
                dogrun_place_id: dogrun_place.id,
                agreement: '1'
              }
            }
          }.to change(Dog, :count).by(1).and change(RegistrationNumber, :count).by(1)

          expect(session[:card_flg]).to be_nil
          expect(session[:fully_flg]).to be_nil
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
          expect(flash[:success]).to eq(I18n.t('local.dog_registrations.dog_registration'))
        end
      end
  
      context '入力パラメータが不正な場合' do
        example '新規作成されずnew formがレンダリングされること' do
          expect {
            post togo_inu_shitsuke_hiroba_dog_registration_path, params: { dog_registration: { name: '' } }
          }.not_to change(Dog, :count)

          expect {
            post togo_inu_shitsuke_hiroba_dog_registration_path, params: { dog_registration: { name: '' } }
          }.not_to change(RegistrationNumber, :count)
  
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:dog_registration).errors).to be_of_kind(:name, :blank)
        end
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        post togo_inu_shitsuke_hiroba_dog_registration_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_dog_registration_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_dog_registration_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
