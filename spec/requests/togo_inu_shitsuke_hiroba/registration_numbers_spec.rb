require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::RegistrationNumbersController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: general) }
  let!(:dog_2) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number) { create(:registration_number, registration_number: "007", dog: dog_2, dogrun_place: dogrun_place) }
  let!(:other) { create(:user, :general) }
  
  describe 'GET #form_selection' do
    context 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正しくレンダリングされること' do
        get togo_inu_shitsuke_hiroba_registration_numbers_form_selection_path
        expect(response).to render_template(:form_selection)
        expect(assigns(:confirmation)).to eq(I18n.t('local.dog_registrations.form_selection.confirmation', registration_card: I18n.t('togo_inu_shitsuke_hiroba.registration_card')))
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_registration_numbers_form_selection_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_registration_numbers_form_selection_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #have_registration_card' do
    context 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'card_flgがtrueに設定されnewリダイレクトされること' do
        get togo_inu_shitsuke_hiroba_registration_numbers_have_registration_card_path
        expect(session[:card_flg]).to be true
        expect(response).to redirect_to(new_togo_inu_shitsuke_hiroba_registration_number_path)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_registration_numbers_have_registration_card_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_registration_numbers_have_registration_card_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #not_have_registration_card' do
    context 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'card_flgがfalseに設定されnewリダイレクトされること' do
        get togo_inu_shitsuke_hiroba_registration_numbers_not_have_registration_card_path
        expect(session[:card_flg]).to be false
        expect(response).to redirect_to(new_togo_inu_shitsuke_hiroba_registration_number_path)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_registration_numbers_not_have_registration_card_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_registration_numbers_not_have_registration_card_path
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
        get new_togo_inu_shitsuke_hiroba_registration_number_path
        expect(assigns(:registration_number)).to be_a_new(RegistrationNumber)
        expect(response).to render_template(:new)
        expect(assigns(:registration_number_hint)).to eq(I18n.t('local.dog_registrations.new.registration_number_hint', registration_card: I18n.t('togo_inu_shitsuke_hiroba.registration_card')))
        expect(response.body).to include(dog_1.name)
        expect(response.body).not_to include(dog_2.name)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get new_togo_inu_shitsuke_hiroba_registration_number_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get new_togo_inu_shitsuke_hiroba_registration_number_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'POST #create' do
    let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place) }

    describe 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      context '正しいパラメータが入力されている場合' do
        example '新規作成されること' do
          expect {
            post togo_inu_shitsuke_hiroba_registration_numbers_path,
            params: {
              registration_number: {
                select_dog: dog_1.id,
                registration_number: "777",
                agreement: '1'
              }
            }
          }.to change(RegistrationNumber, :count).by(1)
          expect(session[:card_flg]).to be nil
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(general))
          expect(flash[:success]).to eq(I18n.t('local.registration_numbers.registered_successfully'))
        end
      end

      describe '不正なパラメータが入力されている場合' do
        context '選択されたワンコが見つからないとき' do
          example '新規作成されないこと' do
            expect {
              post togo_inu_shitsuke_hiroba_registration_numbers_path,
              params: {
                registration_number: {
                  select_dog: "",
                  registration_number: "777",
                  agreement: '1'
                }
              }
            }.not_to change(RegistrationNumber, :count)
            expect(response).to render_template(:new)
            expect(assigns(:registration_number).errors).to be_of_kind(:dog, :unselected_option)
          end
        end

        context 'その他validationが通らないとき' do
          example '新規作成されないこと' do
            expect {
              post togo_inu_shitsuke_hiroba_registration_numbers_path,
              params: {
                registration_number: {
                  select_dog: dog_1.id,
                  registration_number: "",
                  agreement: '1'
                }
              }
            }.not_to change(RegistrationNumber, :count)
            expect(response).to render_template(:new)
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        post togo_inu_shitsuke_hiroba_registration_numbers_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_registration_numbers_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place) }
    
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'registration_numberが削除されuser#show画面にリダイレクトしてメッセージが表示されること' do
        delete  togo_inu_shitsuke_hiroba_registration_number_path(registration_number)
        expect(RegistrationNumber.count).to be_zero
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_user_path(general))
        expect(flash[:success]).to eq(I18n.t('local.registration_numbers.destroy_successfully'))
      end
    end

    describe '紐づいていないユーザーでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(other)
      end

      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          delete togo_inu_shitsuke_hiroba_registration_number_path(registration_number)
        }.not_to change(RegistrationNumber, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_correct_account'))
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect {
          delete togo_inu_shitsuke_hiroba_registration_number_path(registration_number)
        }.not_to change(RegistrationNumber, :count)
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          delete togo_inu_shitsuke_hiroba_registration_number_path(registration_number)
        }.not_to change(RegistrationNumber, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #entries_record_analysis' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        get entries_record_analysis_togo_inu_shitsuke_hiroba_registration_number_path(registration_number)
      end

      example '正常にレンダリングされること' do
        expect(response).to have_http_status(:ok)
        expect(response).to have_http_status(:ok)
        expect(assigns(:notation_of_registration_number)).to eq(I18n.t('togo_inu_shitsuke_hiroba.registration_number'))
      end 
    end

    describe '紐づいていないユーザーでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(other)
        get entries_record_analysis_togo_inu_shitsuke_hiroba_registration_number_path(registration_number)
      end

      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_correct_account'))
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get entries_record_analysis_togo_inu_shitsuke_hiroba_registration_number_path(registration_number)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end 
    end

    describe 'ログインしていないとき' do
      before do
        get entries_record_analysis_togo_inu_shitsuke_hiroba_registration_number_path(registration_number)
      end
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login')) 
      end
    end
  end
end
