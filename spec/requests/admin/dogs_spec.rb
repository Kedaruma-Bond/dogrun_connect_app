require 'rails_helper'

RSpec.describe Admin::DogsController, type: :request do
  let!(:grand_admin_place) { create(:dogrun_place, :grand_admin_place) }
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:grand_admin) { create(:user, :grand_admin, dogrun_place: grand_admin_place) }
  let!(:admin_1) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:admin_2) { create(:user, :admin, dogrun_place: dogrun_place_2) }
  let!(:general) { create(:user, :general) }
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: general) }
  let!(:dog_2) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number_1) { create(:registration_number, dog: dog_1, dogrun_place: dogrun_place_1)}
  let!(:registration_number_2) { create(:registration_number, dog: dog_2, dogrun_place: dogrun_place_2)}
  
  describe 'GET #index' do
    context 'grand_adminユーザーでログインしている場合' do
      before { admin_log_in_as(grand_admin) }

      example '正常なレスポンスが返ること' do
        get admin_dogs_path
        expect(response).to be_successful
      end
    end

    context '管理者ユーザーでログインしている場合' do
      before do
        admin_log_in_as(admin_1) 
        get admin_dogs_path
      end

      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end

      example '登録済の犬が表示されること' do
        expect(response.body).to include(dog_1.name)
      end
      
      example '登録していないの犬が表示されないこと' do
        expect(response.body).not_to include(dog_2.name)
      end
    end

    context '一般ユーザーでログインしている場合' do
      before do
        admin_log_in_as(general) 
        get admin_dogs_path
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #show" do
    context "管理者ユーザーでログインしている時" do
      before do
        admin_log_in_as(admin_1)
      end
      
      example "正常なレスポンスが返り、登録番号がackされること" do
        expect { get admin_dog_path(dog_1) }.to change { registration_number_1.reload.acknowledge }.from(false).to(true)
        expect(response).to be_successful
        expect(response.body).to include(registration_number_1.registration_number)
      end
    end
    
    context '一般ユーザーでログインしている場合' do
      before do
        admin_log_in_as(general) 
        get admin_dog_path(dog_1)
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    context '管理者ユーザーでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        get edit_admin_dog_path(dog_1)
      end

      example "正常なレスポンスが返ること" do
        expect(response).to be_successful
      end
    end
    
    context '一般ユーザーでログインしている場合' do
      before do
        admin_log_in_as(general) 
        get admin_dog_path(dog_1)
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  describe "PATCH #update" do
    describe '管理者ユーザーでログインしているとき' do
      before do
        admin_log_in_as(admin_1)
      end

      context '有効なパラメータが入力されている場合' do
        example '更新されてメッセージとともに一覧ページへリダイレクトされること' do
          patch admin_dog_path(dog_1), params: {
            dog: {
              name: 'New name'
            }
          }
          expect(flash[:success]).to eq(I18n.t('defaults.update_successfully'))
          expect(dog_1.reload.name).to eq('New name')
          expect(response).to redirect_to(admin_dogs_path)
        end
      end

      context '無効なパラメータが入力されている場合' do
        example '更新されず編集フォームページがレンダリングされること' do
          expect {
            patch admin_dog_path(dog_1), params: {
                dog: {
                  name: ''
                }
              }
            }.to_not change { dog_1.reload.name }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
        end
      end
    end
  end

end
