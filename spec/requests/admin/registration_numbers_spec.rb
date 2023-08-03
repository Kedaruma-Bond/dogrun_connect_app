require 'rails_helper'

RSpec.describe Admin::RegistrationNumbersController, type: :request do
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:admin_1) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number_1) { create(:registration_number, registration_number: "007", dog: dog_1, dogrun_place: dogrun_place_1) }
  let!(:registration_number_2) { create(:registration_number, registration_number: "222", dog: dog_1, dogrun_place: dogrun_place_2) }

  describe 'PATCH #update' do
    describe '管理者ユーザーでログインしているとき' do
      before do
        admin_log_in_as(admin_1)
      end

      context '有効なパラメータが入力された場合' do
        example '更新できること' do
          patch admin_registration_number_path(registration_number_1), 
          params: { 
            registration_number: {
              registration_number: "1192"
            }
          }
          expect(registration_number_1.reload.registration_number).to eq("1192")
          expect(flash[:success]).to eq(I18n.t('admin.registration_numbers.update.registration_number_updated_successfully'))
          expect(response).to redirect_to(admin_dogs_path)
        end
      end

      context '無効なパラメータが入力された場合' do
        example '更新されずエラーメッセージが表示されること' do
          patch admin_registration_number_path(registration_number_1), 
          params: { 
            registration_number: {
              registration_number: ""
            }
          }
          expect(registration_number_1.reload.registration_number).to eq("007")
          expect(flash[:error]).to eq(I18n.t('admin.registration_numbers.update.registration_number_updated_error'))
          expect(response).to redirect_to(admin_dogs_path)
        end
      end

      context '他のドッグランの登録番号を更新しようとした場合' do
        example '更新されずエラーメッセージが表示されること' do
          patch admin_registration_number_path(registration_number_2)
          
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        patch admin_registration_number_path(registration_number_1) 
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
        patch admin_registration_number_path(registration_number_1) 
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        patch admin_registration_number_path(registration_number_1) 
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
