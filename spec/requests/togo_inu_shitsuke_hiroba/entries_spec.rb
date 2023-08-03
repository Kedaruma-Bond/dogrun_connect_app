require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::EntriesController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_other) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }
  let!(:dog) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number) { create(:registration_number, registration_number: "007", dog: dog, dogrun_place: dogrun_place) }
  let!(:registration_number_other) { create(:registration_number, registration_number: "008", dog: dog, dogrun_place: dogrun_place_other) }

  describe 'GET #index' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get togo_inu_shitsuke_hiroba_entries_path
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_entries_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_entries_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'POST #create' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      describe 'ドッグランが営業中の場合' do
        describe 'プレエントリーしていないとき' do
          context 'params[:select_dog]がblankの場合' do
            example 'dogrunのtop画面リダイレクトされエラーメッセージが表示されること' do
              expect {
                post togo_inu_shitsuke_hiroba_entries_path, 
                params: {
                  pre_flg: "0",                      
                  select_dog: ""
                }
              }.not_to change(Entry, :count)
              expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
              expect(flash[:error]).to eq(I18n.t('local.entries.pre_entry_has_been_expired'))
              expect(response).to have_http_status(:found) 
            end
          end

          describe '入場する場合' do
            describe 'ユーザーのワンコの入場中の記録がないとき' do
              context 'ワンコが選択されている場合' do
                example '入場記録が作成できること' do
                  expect {
                    post togo_inu_shitsuke_hiroba_entries_path, 
                    params: {
                      pre_flg: "0",                      
                      select_dog: {"#{dog.name}": "1"}
                    }
                  }.to change(Entry, :count).by(1)
                  expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
                  expect(flash[:success]).to eq(I18n.t('local.entries.entry_success'))
                  expect(response).to have_http_status(:found)
                end
              end

              context 'ワンコが選択されていない場合' do
                example 'ドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
                  post togo_inu_shitsuke_hiroba_entries_path, 
                  params: {
                    pre_flg: "0",                      
                    select_dog: {"#{dog.name}": "0"}
                  }
                  expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
                  expect(flash[:error]).to eq(I18n.t('local.entries.select_entry_dog'))
                  expect(response).to have_http_status(:found)
                end
              end
            end

            describe '該当ワンコの入場中の記録があるとき' do
              let!(:entry_1) { create(:entry, :not_exit, dog: dog, registration_number: registration_number_other) }

              example '入場記録が作成されずドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
                  expect {
                    post togo_inu_shitsuke_hiroba_entries_path, 
                    params: {
                      pre_flg: "0",                      
                      select_dog: {"#{dog.name}": "1"}
                    }
                  }.not_to change(Entry, :count)
                  expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
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
                    post togo_inu_shitsuke_hiroba_entries_path, 
                    params: {
                      pre_flg: '1',
                      select_dog: {"#{dog.name}": "1"}
                    }
                  }.to change(PreEntry, :count).by(1)
                  expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
                  expect(flash[:success]).to eq(I18n.t('local.entries.pre_entry_success'))
                  expect(response).to have_http_status(:found)
                end
              end

              context 'ワンコが選択されていない場合' do
                example 'ドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
                  post togo_inu_shitsuke_hiroba_entries_path, 
                  params: {
                    pre_flg: "1",                      
                    select_dog: {"#{dog.name}": "0"}
                  }
                  expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
                  expect(flash[:error]).to eq(I18n.t('local.entries.select_pre_entry_dog'))
                  expect(response).to have_http_status(:found)
                end
              end
            end

            describe '該当わんこのプレエントリー中の記録があるとき' do
              let!(:pre_entry_1) { create(:pre_entry, dog: dog, registration_number: registration_number_other) }
              example 'ドッグランのtop画面にリダイレクトされエラーメッセージが表示されること' do
                  expect {
                    post togo_inu_shitsuke_hiroba_entries_path, 
                    params: {
                      pre_flg: "1",                      
                      select_dog: {"#{dog.name}": "1"}
                    }
                  }.not_to change(PreEntry, :count)
                  expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
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
              post togo_inu_shitsuke_hiroba_entries_path, 
              params: {
                pre_flg: "1",                      
                select_dog: {"#{dog.name}": "1"}
              }
            }.to change(Entry, :count).to(1)
            expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
            expect(flash[:success]).to eq(I18n.t('local.entries.entry_success'))
            expect(response).to have_http_status(:found)
          end

          example 'プレエントリー記録が削除されること' do
            post togo_inu_shitsuke_hiroba_entries_path, 
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
          post togo_inu_shitsuke_hiroba_entries_path
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
          expect(flash[:error]).to eq(I18n.t('local.entries.dogrun_is_closing_now'))
          expect(response).to have_http_status(:found)
        end
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        post togo_inu_shitsuke_hiroba_entries_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_entries_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'PATCH #update' do
    let!(:entry_2) { create(:entry, :not_exit, dog: dog, registration_number: registration_number) }

    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example 'updates the exit_at attribute of the entry' do
        patch("/togo_inu_shitsuke_hiroba/entry")
        entry_2.reload
        expect(entry_2.exit_at).to be_present
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
        expect(flash[:success]).to eq(I18n.t('local.entries.exit_success'))
        expect(response).to have_http_status(:found)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        patch("/togo_inu_shitsuke_hiroba/entry")
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        patch("/togo_inu_shitsuke_hiroba/entry")
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'GET #search' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get search_togo_inu_shitsuke_hiroba_entries_path
        expect(response).to render_template(:search)
        expect(response).to have_http_status(:ok)
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get search_togo_inu_shitsuke_hiroba_entries_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get search_togo_inu_shitsuke_hiroba_entries_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:entry_3){ create(:entry, dog: dog, registration_number: registration_number) }
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end
      
      context 'ログインしているアカウントに紐づいたdogのentryを削除する場合' do
        example 'entryが削除されdogrunのtop画面にリダイレクトしてエラーメッセージが表示されること' do
          delete togo_inu_shitsuke_hiroba_entry_path(entry_3)
          expect(Entry.count).to be_zero
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_entries_path)
          expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
        end
      end

      context '別のアカウントに紐づいたdogのentryを削除する場合' do
        let!(:user) { create(:user, :general) }
        let!(:dog_other_user) { create(:dog, :castrated, :public_view, user: user) }
        let!(:registration_number_other_user) { create(:registration_number, registration_number: "777", dog: dog_other_user, dogrun_place: dogrun_place) }
        let!(:entry_4){ create(:entry, dog: dog_other_user, registration_number: registration_number_other_user) }
        example '削除できないこと' do
          expect {
            delete togo_inu_shitsuke_hiroba_entry_path(entry_4)
          }.not_to change(Entry, :count)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_entries_path)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect {
          delete togo_inu_shitsuke_hiroba_entry_path(entry_3)
        }.not_to change(Entry, :count)
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          delete togo_inu_shitsuke_hiroba_entry_path(entry_3)
        }.not_to change(Entry, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
