require 'rails_helper'

RSpec.describe Admin::DogrunPlacesController, type: :request do
  let!(:grand_admin_place) { create(:dogrun_place, :grand_admin_place) }
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:grand_admin) { create(:user, :grand_admin, dogrun_place: grand_admin_place) }
  let!(:admin_1) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:admin_2) { create(:user, :admin, dogrun_place: dogrun_place_2) }
  let!(:general) { create(:user, :general) }

  describe 'GET #index' do
    context 'grand_adminユーザーでログインしている場合' do
      before do
        admin_log_in_as(grand_admin)
        get admin_dogrun_places_path
      end
      
      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end
    end

    context '管理者ユーザーでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        get admin_dogrun_places_path
      end

      example 'エラーメッセージが表示されて管理者home画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
    
    context '一般ユーザーでログインしている場合' do
      before do
        admin_log_in_as(general)
        get admin_dogrun_places_path
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

  end

  describe 'GET #show' do
    context 'grand_adminユーザーでログインしている場合' do
      before do
        admin_log_in_as(grand_admin)
        get admin_dogrun_place_path(dogrun_place_1)
      end
      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end
    end

    context '該当ドッグランの管理者ユーザーでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        get admin_dogrun_place_path(dogrun_place_1)
      end

      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end
    end
    
    context '該当ドッグランとは別の管理者ユーザーでログインしている場合' do
      before do
        admin_log_in_as(admin_2)
        get admin_dogrun_place_path(dogrun_place_1)
      end

      example 'エラーメッセージが表示されて管理者home画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
    
    context '一般ユーザーでログインしている場合' do
      before do
        admin_log_in_as(general)
        get admin_dogrun_place_path(dogrun_place_1)
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  describe 'GET #new' do
    context 'grand_adminユーザーでログインしている場合' do
      before do
        admin_log_in_as(grand_admin)
        get new_admin_dogrun_place_path
      end

      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end
    end

    context '管理者ユーザーでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        get new_admin_dogrun_place_path
      end

      example 'エラーメッセージが表示されて管理者home画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
    
    context '一般ユーザーでログインしている場合' do
      before do
        admin_log_in_as(general)
        get new_admin_dogrun_place_path
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do

    describe 'grand_adminユーザーでログインしている時' do
      before { admin_log_in_as(grand_admin) }
      context '有効なパラメータが入力された場合' do
        example '新規作成されて一覧画面にリダイレクトされること' do
          expect {
            post admin_dogrun_places_path, 
            params: {
              dogrun_place: {
                name: 'test'
              }
            }
          }.to change(DogrunPlace, :count).by(1)
          expect(flash[:success]).to eq(I18n.t('admin.dogrun_places.create.create_success'))
          expect(response).to redirect_to(admin_dogrun_places_path)
        end
      end

      context '無効なパラメータが入力された場合' do
        example '新規作成されずnewフォーム画面がレンダリングされること' do
          expect {
            post admin_dogrun_places_path, 
            params: {
              dogrun_place: {
                name: ''
              }
            }
          }.to_not change(DogrunPlace, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end
      end
    end

    describe '管理者ユーザーでログインしている時' do
      before do
        admin_log_in_as(admin_1)
        post admin_dogrun_places_path
      end
      example 'エラーメッセージが表示されて管理者home画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'grand_adminユーザーでログインしている場合' do
      before do
        admin_log_in_as(grand_admin)
        get edit_admin_dogrun_place_path(dogrun_place_1)
      end

      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end
    end

    context '該当ドッグランの管理者ユーザーでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        get edit_admin_dogrun_place_path(dogrun_place_1)
      end

      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end
    end
    
    context '該当ドッグランとは別の管理者ユーザーでログインしている場合' do
      before do
        admin_log_in_as(admin_2)
        get edit_admin_dogrun_place_path(dogrun_place_1)
      end

      example 'エラーメッセージが表示されて管理者home画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
    
    context '一般ユーザーでログインしている場合' do
      before do
        admin_log_in_as(general)
        get admin_dogrun_place_path(dogrun_place_1)
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    describe 'grand_adminユーザーでログインしている時' do
      before do
        admin_log_in_as(grand_admin) 
      end
      context '有効なパラメータが入力されている場合' do
        example '更新されてメッセージとともに一覧ページにリダイレクトされること' do
          patch admin_dogrun_place_path(dogrun_place_1), params: {
                dogrun_place: {
                  name: 'New name'
                }
              }
          expect(flash[:success]).to eq(I18n.t('defaults.update_successfully'))
          expect(dogrun_place_1.reload.name).to eq('New name')
          expect(response).to redirect_to(admin_dogrun_places_path)
        end
      end

      context '無効なパラメータが入力されている場合' do
        example '更新されず編集フォームページがレンダリングされること' do
          expect {
            patch admin_dogrun_place_path(dogrun_place_1), params: {
                dogrun_place: {
                  name: ''
                }
              }
            }.to_not change { dogrun_place_1.reload.name }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
        end
      end
    end

    describe '該当ドッグランの管理者ユーザーでログインしている時' do
      before { admin_log_in_as(admin_1) }

      context '有効なパラメータが入力させている場合' do
        example '更新されてメッセージとともに詳細ページにリダイレクトされること' do
          patch admin_dogrun_place_path(dogrun_place_1), params: {
                dogrun_place: {
                  name: 'New name'
                }
              }
          expect(flash[:success]).to eq(I18n.t('defaults.update_successfully'))
          expect(dogrun_place_1.reload.name).to eq('New name')
          expect(response).to redirect_to(admin_dogrun_place_path(dogrun_place_1))
        end
      end
      
      context '無効なパラメータが入力されている場合' do
        example '更新されず編集フォームページがレンダリングされること' do
          expect {
            patch admin_dogrun_place_path(dogrun_place_1), params: {
                dogrun_place: {
                  name: ''
                }
              }
            }.to_not change { dogrun_place_1.reload.name }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
        end
      end
    end

    describe '該当ドッグランとは別の管理者ユーザーでログインしている時' do
      before do
        admin_log_in_as(admin_2) 
        patch admin_dogrun_place_path(dogrun_place_1)
      end
      example 'エラーメッセージが表示され管理者home画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end
  
  describe 'PATCH #force_closed' do
    describe '該当ドッグランの管理者ユーザーでログインしている時' do
      before { admin_log_in_as(admin_1) }
      example 'ドッグランが休業状態となること' do
        expect do
          patch force_closed_admin_dogrun_place_path(dogrun_place_1)
          dogrun_place_1.reload
        end.to change { dogrun_place_1.force_closed }.from("releasing").to("force_closing")
        .and change { dogrun_place_1.closed_flag }.from(false).to(true)
      end
    end

    describe '該当ドッグランとは別の管理者ユーザーでログインしている時' do
      before do
        admin_log_in_as(admin_2)
        patch force_closed_admin_dogrun_place_path(dogrun_place_1)
      end
      example 'エラーメッセージが表示され管理者home画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end

  describe 'PATCH #release' do
    let!(:closed_dogrun) { create(:dogrun_place, :force_closed) }
    let!(:admin) { create(:user, :admin, dogrun_place: closed_dogrun) }
    
    describe '該当ドッグランの管理者ユーザーでログインしている時' do
      before do
        admin_log_in_as(admin)
      end
      example 'ドッグランが休業状態となること' do
        expect do
          patch release_admin_dogrun_place_path(closed_dogrun)
          closed_dogrun.reload
        end.to change { closed_dogrun.force_closed }.from("force_closing").to("releasing")
        .and change { closed_dogrun.closed_flag }.from(true).to(false)
      end
    end

    describe '該当ドッグランとは別の管理者ユーザーでログインしている時' do
      before do
        admin_log_in_as(admin_1)
        patch release_admin_dogrun_place_path(closed_dogrun)
      end
      example 'エラーメッセージが表示され管理者home画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end
end
