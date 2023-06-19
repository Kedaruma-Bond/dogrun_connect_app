require 'rails_helper'

RSpec.describe Reon::EntriesController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:dogrun_place_other) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:dog) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number) { create(:registration_number, registration_number: "007", dog: dog, dogrun_place: dogrun_place) }
  let!(:registration_number_other) { create(:registration_number, registration_number: "008", dog: dog, dogrun_place: dogrun_place_other) }

  describe 'GET #index' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get reon_entries_path
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get reon_entries_path
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

      describe 'ドッグランが営業中の場合' do
        describe 'プレエントリーしていないとき' do
          describe '入場する場合' do
            describe 'ユーザーのワンコの入場中の記録がないとき' do
              context 'ワンコが選択されている場合' do
                example '入場記録が作成できること' do
                  expect {
                    post reon_entries_path, 
                    params: {
                      pre_flg: "0",                      
                      select_dog: {"#{dog.name}": "1"}
                    }
                  }.to change(Entry, :count).by(1)
                  expect(response).to redirect_to(reon_top_path)
                  expect(flash[:success]).to eq(I18n.t('local.entries.entry_success'))
                  expect(response).to have_http_status(:found)
                end
              end

              context 'ワンコが選択されていない場合' do
                example 'ドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
                  post reon_entries_path, 
                  params: {
                    pre_flg: "0",                      
                    select_dog: {"#{dog.name}": "0"}
                  }
                  expect(response).to redirect_to(reon_top_path)
                  expect(flash[:error]).to eq(I18n.t('local.entries.select_entry_dog'))
                  expect(response).to have_http_status(:found)
                end
              end
            end

            describe '該当ワンコの入場中の記録があるとき' do
              let!(:entry_1) { create(:entry, :not_exit, dog: dog, registration_number: registration_number_other) }

              example '入場記録が作成されずドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
                  expect {
                    post reon_entries_path, 
                    params: {
                      pre_flg: "0",                      
                      select_dog: {"#{dog.name}": "1"}
                    }
                  }.not_to change(Entry, :count)
                  expect(response).to redirect_to(reon_top_path)
                  expect(flash[:error]).to eq(I18n.t('local.entries.select_dog_has_already_entered'))
                  expect(response).to have_http_status(:found)
                
              end
            end
          end

          describe 'プレエントリーする場合' do
            describe '該当ワンコのプレエントリー中の記録がないとき' do
              context 'ワンコが選択されている場合' do
                example 'プレエントリー記録が作成できること' do
                  expect {
                    post reon_entries_path, 
                    params: {
                      pre_flg: '1',
                      select_dog: {"#{dog.name}": "1"}
                    }
                  }.to change(PreEntry, :count).by(1)
                  expect(response).to redirect_to(reon_top_path)
                  expect(flash[:success]).to eq(I18n.t('local.entries.pre_entry_success'))
                  expect(response).to have_http_status(:found)
                end
              end

              context 'ワンコが選択されていない場合' do
                example 'ドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
                  post reon_entries_path, 
                  params: {
                    pre_flg: "1",                      
                    select_dog: {"#{dog.name}": "0"}
                  }
                  expect(response).to redirect_to(reon_top_path)
                  expect(flash[:error]).to eq(I18n.t('local.entries.select_pre_entry_dog'))
                  expect(response).to have_http_status(:found)
                end
              end
            end

            describe '該当わんこのプレエントリー中の記録があるとき' do
              let!(:pre_entry_1) { create(:pre_entry, dog: dog, registration_number: registration_number_other) }
              example 'ドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
                  expect {
                    post reon_entries_path, 
                    params: {
                      pre_flg: "1",                      
                      select_dog: {"#{dog.name}": "1"}
                    }
                  }.not_to change(PreEntry, :count)
                  expect(response).to redirect_to(reon_top_path)
                  expect(flash[:error]).to eq(I18n.t('local.entries.select_dog_has_already_pre_entered'))
                  expect(response).to have_http_status(:found)
              end
            end
          end
        end

        describe 'プレエントリーしているとき' do
          let!(:pre_entry_2) { create(:pre_entry, dog: dog, registration_number: registration_number) }

          example '入場記録が作成されること' do
            expect {
              post reon_entries_path, 
              params: {
                pre_flg: "1",                      
                select_dog: {"#{dog.name}": "1"}
              }
            }.to change(Entry, :count).to(1)
            expect(response).to redirect_to(reon_top_path)
            expect(flash[:success]).to eq(I18n.t('local.entries.entry_success'))
            expect(response).to have_http_status(:found)
          end

          example 'プレエントリー記録が削除されること' do
            post reon_entries_path, 
            params: {
              pre_flg: "1",                      
              select_dog: {"#{dog.name}": "1"}
            }
            expect(PreEntry.count).to eq(0)
          end
        end
      end

      describe 'ドッグランが休業している場合' do
        before do
          dogrun_place.update(closed_flag: true)
        end

        example 'ドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
          post reon_entries_path
          expect(response).to redirect_to(reon_top_path)
          expect(flash[:error]).to eq(I18n.t('local.entries.dogrun_is_closing_now'))
          expect(response).to have_http_status(:found)
        end
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post reon_entries_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'PATCH #update' do
    let!(:entry_2) { create(:entry, :not_exit, dog: dog, registration_number: registration_number) }

    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example 'updates the exit_at attribute of the entry' do
        patch("/reon/entry")
        entry_2.reload
        expect(entry_2.exit_at).to be_present
        expect(response).to redirect_to(reon_top_path)
        expect(flash[:success]).to eq(I18n.t('local.entries.exit_success'))
        expect(response).to have_http_status(:found)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        patch("/reon/entry")
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #search' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get search_reon_entries_path
        expect(response).to render_template(:search)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get search_reon_entries_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:entry_3){ create(:entry, dog: dog, registration_number: registration_number) }
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end
      
      example 'destroys the entry' do
        delete reon_entry_path(entry_3)
        expect(Entry.count).to be_zero
        expect(response).to redirect_to(reon_entries_path)
        expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
      end
    end
    
    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          delete reon_entry_path(entry_3)
        }.not_to change(Entry, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
