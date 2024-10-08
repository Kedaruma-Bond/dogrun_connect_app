require 'rails_helper'

RSpec.describe Reon::DogsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }
  let!(:dog) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number) { create(:registration_number, dog: dog, dogrun_place: dogrun_place)}

  describe 'GET #show' do
    let!(:dogrun_place_2) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
    let!(:registration_number_2) { create(:registration_number, dog: dog, dogrun_place: dogrun_place_2)}
    let!(:dog_another) { create(:dog, :castrated, :public_view, user: general) }
    let!(:registration_number_another) { create(:registration_number, dog: dog_another, dogrun_place: dogrun_place)}
    let!(:other) { create(:user, :general) }
    let!(:dog_other) { create(:dog, :castrated, :public_view, user: other) }
    let!(:registration_number_other) { create(:registration_number, dog: dog_other, dogrun_place: dogrun_place)}
    let!(:entry_0) { create(:entry, entry_at: DateTime.now - 0, dog: dog, registration_number: registration_number) }
    let!(:entry_1) { create(:entry, entry_at: DateTime.now - 1, dog: dog, registration_number: registration_number) }
    let!(:entry_2) { create(:entry, entry_at: DateTime.now - 2, dog: dog, registration_number: registration_number) }
    let!(:entry_3) { create(:entry, entry_at: DateTime.now - 3, dog: dog, registration_number: registration_number) }
    let!(:entry_4) { create(:entry, entry_at: DateTime.now - 4, dog: dog, registration_number: registration_number) }
    let!(:entry_another) { create(:entry, entry_at: DateTime.now - 6, dog: dog_another, registration_number: registration_number_another) }
    let!(:entry_5) { create(:entry, entry_at: DateTime.now - 5, dog: dog, registration_number: registration_number) }
    let!(:encount_0) { create(:encount, user: general, dog: dog_other, entry: entry_0, dogrun_place: dogrun_place ) }
    let!(:encount_1) { create(:encount, user: general, dog: dog_other, entry: entry_1, dogrun_place: dogrun_place ) }
    let!(:encount_2) { create(:encount, user: general, dog: dog_other, entry: entry_2, dogrun_place: dogrun_place ) }
    let!(:encount_3) { create(:encount, user: general, dog: dog_other, entry: entry_3, dogrun_place: dogrun_place ) }
    let!(:encount_4) { create(:encount, user: general, dog: dog_other, entry: entry_4, dogrun_place: dogrun_place ) }
    let!(:encount_5) { create(:encount, user: general, dog: dog_other, entry: entry_5, dogrun_place: dogrun_place ) }
    let!(:encount_another) { create(:encount, user: general, dog: dog_other, entry: entry_another, dogrun_place: dogrun_place ) }
    
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example '直近x以上のentryに紐づいたencountが削除され正常なレスポンスがかえること' do
        get reon_dog_path(dog_other)
        get togo_inu_shitsuke_hiroba_dog_path(dog)
        get reon_dog_path(dog)
        expect(response).to be_successful
        expect(assigns(:entries)).to match_array(Entry.where(dog: dog, registration_number_id: registration_number.id).joins(:registration_number).where(registration_number: { dogrun_place: dogrun_place }).order(created_at: :desc))
        expect(Encount.count).to eq(6)
        expect(Encount.last).to eq(encount_another)
        expect(Encount.last(2).first).to eq(encount_4)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get reon_dog_path(dog)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get reon_dog_path(dog)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #edit' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get edit_reon_dog_path(dog)
        expect(response).to be_successful
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get edit_reon_dog_path(dog)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get edit_reon_dog_path(dog)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) { { dog: { name: 'Updated Dog' } } }

    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      context '有効なパラメータが入力されている場合' do
        example '更新されること' do
          patch reon_dog_path(dog), params: valid_params
          expect(response).to redirect_to(reon_dog_path(dog))
          dog.reload
          expect(dog.name).to eq('Updated Dog')
        end
      end
  
      context '無効なパラメータが入力されている場合' do
        it '更新されずedit formが表示されること' do
          patch reon_dog_path(dog), params: { dog: { name: '' } }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
          expect(assigns(:dog).errors).to be_of_kind(:name, :blank)
        end
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        patch reon_dog_path(dog)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        patch reon_dog_path(dog)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
