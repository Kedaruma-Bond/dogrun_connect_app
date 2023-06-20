require 'rails_helper'

RSpec.describe Reon::DogFullyRegistrationController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }

  describe 'GET #form_selection' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example '正しくレンダリングされること' do
        get reon_dog_fully_registration_form_selection_path
        expect(response).to render_template(:form_selection)
        expect(assigns(:confirmation)).to eq(I18n.t('local.dog_registrations.form_selection.confirmation', registration_card: I18n.t('reon.registration_card')))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get reon_dog_fully_registration_form_selection_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #have_registration_card' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example 'card_flgがtrueに設定されnewリダイレクトされること' do
        get reon_dog_fully_registration_have_registration_card_path
        expect(session[:card_flg]).to be true
        expect(response).to redirect_to(reon_dog_fully_registration_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get reon_dog_fully_registration_have_registration_card_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #not_have_registration_card' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example 'card_flgがfalseに設定されnewリダイレクトされること' do
        get reon_dog_fully_registration_not_have_registration_card_path
        expect(session[:card_flg]).to be false
        expect(response).to redirect_to(reon_dog_fully_registration_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get reon_dog_registration_not_have_registration_card_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #new' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get reon_dog_fully_registration_path
        expect(response).to render_template(:new)
        expect(assigns(:registration_number_hint)).to eq(I18n.t('local.dog_registrations.new.registration_number_hint', registration_card: I18n.t('reon.registration_card')))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get reon_dog_fully_registration_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'POST #create' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      context '正しいパラメータが入力されている場合' do
        example 'DogとRegistrationNumberが作成されること' do
          expect {
            post reon_dog_fully_registration_path,
            params: {
              dog_fully_registration: {
                name: "bond",
                thumbnail: fixture_file_upload("/images/bond_icon.png", "image/png"),
                castration: "castrated",
                public: "public_view",
                birthday: Date.today - 1.year,
                breed: "Whippet",
                sex: "male",
                weight: 10,
                mixed_vaccination_certificate: fixture_file_upload("/images/photo_of_mixed_vaccination_certificate.jpg", "image/jpg"),
                date_of_mixed_vaccination: Date.today - 1.month,
                rabies_vaccination_certificate: fixture_file_upload("/images/photo_of_rabies_vaccination_certificate.jpg", "image/jpg"),
                date_of_rabies_vaccination: Date.today - 1.month,
                registration_prefecture_code: 13,
                registration_municipality: "渋谷区",
                municipal_registration_number: "12345",
                license_plate: fixture_file_upload("/images/photo_of_license_plate.jpg", "image/jpg"),
                user_id: general.id,
                registration_number: "12345",
                dogrun_place_id: dogrun_place.id,
                agreement: '1'
              }
            }
          }.to change(Dog, :count).by(1).and change(RegistrationNumber, :count).by(1)

          expect(session[:card_flg]).to be_nil
          expect(session[:fully_flg]).to be_nil
          expect(response).to redirect_to(reon_top_path)
          expect(flash[:success]).to eq(I18n.t('local.dog_registrations.dog_registration'))
        end
      end
  
      context '入力パラメータが不正な場合' do
        example '新規作成されずnew formがレンダリングされること' do
          expect {
            post reon_dog_fully_registration_path, params: { dog_fully_registration: { name: '' } }
          }.not_to change(Dog, :count)

          expect {
            post reon_dog_fully_registration_path, params: { dog_fully_registration: { name: '' } }
          }.not_to change(RegistrationNumber, :count)
  
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:dog_fully_registration).errors).to be_of_kind(:name, :blank)
        end
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post reon_dog_fully_registration_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
