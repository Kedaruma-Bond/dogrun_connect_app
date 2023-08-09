require 'rails_helper'

RSpec.describe Admin::EmbedsController, type: :request do
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }
  let!(:post_1) { create(:post, :embed, dogrun_place: dogrun_place_1) }
  let!(:post_2) { create(:post, :embed, dogrun_place: dogrun_place_2) }
  let!(:post_3) { create(:post, :article) }
  let!(:embed_1) { create(:embed, :instagram, post: post_1) }
  let!(:embed_2) { create(:embed, :instagram, post: post_2) }

  describe 'GET #new' do

    describe '管理者ユーザーでログイン時' do

      before do
        admin_log_in_as(admin)
      end

      context 'post_typeがembedのpostが作成されているとき' do
        before { get new_admin_embed_path(id: post_1.id) }

        example 'newテンプレートが表示されること' do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:new)
        end
      end

      context 'post_typeがarticleのpostが作成されているとき' do
        before { get new_admin_embed_path(id: post_3.id) }

        example 'エラーメッセージが表示されてadmin_posts_pathにリダイレクトされること' do
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
          expect(response).to redirect_to(admin_posts_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin)
        admin.update(deactivation: 'account_frozen')
        get new_admin_embed_path(id: post_1.id)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe '一般ユーザーでログインしている場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        get new_admin_embed_path(id: post_1.id)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていない場合' do
      before do
        get new_admin_embed_path(id: post_1.id)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'POST #create' do
    describe '管理者ユーザーでログイン時' do
      before { admin_log_in_as(admin) }

      context '全てのフィールドが正しく入力されている場合' do
        example 'articleが新規作成され、投稿一覧ページにリダイレクトされること' do
          expect {
            post admin_embed_path(post_1), 
            params: { 
              embed: {
                embed_type: 'twitter',
                identifier: 'test'
              } 
            }
          }.to change(Embed, :count).by(1)
          expect(response).to redirect_to(admin_posts_path)
        end
      end

      context '入力内容に不備がある場合' do
        example '新規作成されず、new_pageがレンダリングされること' do
          expect {
            post admin_embed_path(post_1), 
            params: { 
              embed: {
                embed_type: '',
                content: ''
              }
            }
          }.not_to change(Embed, :count)
          expect(response).to render_template(:new)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin)
        admin.update(deactivation: 'account_frozen')
        post admin_embed_path(post_1)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe '一般ユーザーでログインしている場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        post admin_embed_path(post_1)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていない時' do
      example '新規作成されずadmin_login_pathにリダイレクトされること' do
        expect {
          post admin_embed_path(post_1)
        }.not_to change(Embed, :count)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'GET #edit' do
    describe '管理者ユーザでログインしている時' do
      before { admin_log_in_as(admin) }

      context '該当articleが存在する場合' do
        before { get edit_admin_embed_path(embed_1.post_id) }
  
        example '正常なレスポンスが返ること' do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
          expect(assigns(:embed)).to eq(embed_1)
        end
      end

      context '別のドッグランのpostに紐づいたembedを編集する場合' do
        before { get edit_admin_embed_path(embed_2.post_id) }

        example 'ホーム画面にリダイレクトされエラーメッセージが表示されること' do
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin)
        admin.update(deactivation: 'account_frozen')
        get edit_admin_embed_path(embed_1.post_id)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe '一般ユーザーでログインしている場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        get edit_admin_embed_path(embed_1.post_id)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていない時' do
      before { get edit_admin_embed_path(embed_1.post_id) }
      example 'admin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end 
    end
  end

  describe 'PATCH #update' do
    describe '管理者ユーザーでログイン時' do
      before do
        admin_log_in_as(admin)
      end
      
      context '全てのフィールドが正しく入力されている場合' do
        before do
          patch admin_embed_path(embed_1.post_id), 
          params: { 
            embed: {
              embed_type: 'twitter',
              identifier: 'test'
            } 
          }
        end
        example '更新され、投稿一覧ページリダイレクトされること' do
          expect(embed_1.reload.embed_type).to eq('twitter') 
          expect(embed_1.reload.identifier).to eq('test') 
          expect(response).to redirect_to(admin_posts_path)
          expect(flash[:success]).to eq(I18n.t('defaults.update_successfully'))
        end
      end

      context '入力内容に不備がある場合' do
        before do
          patch admin_embed_path(embed_1.post_id), 
          params: { 
            embed: {
              embed_type: '',
              identifier: ''
            }
          }
        end
        example '更新されず、edit_pageがレンダリングされること' do
          expect(embed_1.reload.embed_type).not_to be_empty
          expect(embed_1.reload.identifier).not_to be_empty
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
        end
      end

      context '別のドッグランのpostに紐づいたembedを更新する場合' do
        before { patch admin_embed_path(embed_2.post_id) }
        
        example 'ホーム画面にリダイレクトされエラーメッセージが表示されること' do
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end
    
    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin)
        admin.update(deactivation: 'account_frozen')
        patch admin_embed_path(embed_1.post_id)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe '一般ユーザーでログインしている場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        patch admin_embed_path(embed_1.post_id)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていない時' do
      before do
        patch admin_embed_path(embed_1.post_id)
      end
      example '新規作成されずadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
