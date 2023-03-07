require 'rails_helper'

RSpec.describe 'Admin::Articles', type: :request do
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }
  let!(:post_1) { create(:post, :article) }
  let!(:post_2) { create(:post, :embed) }
  let!(:article) { create(:article) }

  describe 'GET #new' do

    describe '管理者ユーザーでログイン時' do

      before do
        admin_log_in_as(admin)
      end

      context 'post_typeがarticleのpostが作成されているとき' do
        before { get new_admin_article_path(id: post_1.id) }

        example 'newテンプレートが表示されること' do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:new)
        end
      end

      context 'post_typeがembedのpostが作成されているとき' do
        before { get new_admin_article_path(id: post_2.id) }

        example 'エラーメッセージが表示されてadmin_posts_pathにリダイレクトされること' do
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
          expect(response).to redirect_to(admin_posts_path)
        end
      end

    end

    describe '一般ユーザーでログインしている場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        get new_admin_article_path(id: post_1.id)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていない場合' do
      before do
        get new_admin_article_path(id: post_1.id)
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
            post admin_article_path(post_1), 
            params: { 
              article: {
                content: 'test_content'
              } 
            }
          }.to change(Article, :count).by(1)
          expect(response).to redirect_to(admin_posts_path)
        end
      end

      context '入力内容に不備がある場合' do
        example '新規作成されず、new_pageがレンダリングされること' do
          expect {
            post admin_article_path(post_1), 
            params: { 
              article: {
                content: ''
              }
            }
          }.not_to change(Article, :count)
          expect(response).to render_template(:new)
        end
      end
    end

    describe '一般ユーザーでログインしている場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        post admin_article_path(post_1)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていない時' do
      example '新規作成されずadmin_login_pathにリダイレクトされること' do
        expect {
          post admin_article_path(post_1)
        }.not_to change(Article, :count)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'GET #edit' do
    describe '管理者ユーザでログインしている時' do
      before { admin_log_in_as(admin) }

      context '該当articleが存在する場合' do
        before { get edit_admin_article_path(article.post_id) }
  
        example '正常なレスポンスが返ること' do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
          expect(assigns(:article)).to eq(article)
        end
      end
    end

    describe '一般ユーザーでログインしている場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        get edit_admin_article_path(article.post_id)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていない時' do
      before { get edit_admin_article_path(article.post_id) }
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
          patch admin_article_path(article.post_id), 
          params: { 
            article: {
              content: 'test_content'
            } 
          }
        end
        example '更新され、投稿一覧ページにリダイレクトされること' do
          expect(article.reload.content).to eq('test_content') 
          expect(response).to redirect_to(admin_posts_path)
          expect(flash[:success]).to eq(I18n.t('defaults.update_successfully'))
        end
      end

      context '入力内容に不備がある場合' do
        before do
          patch admin_article_path(article.post_id), 
          params: { 
            article: {
              content: ''
            }
          }
        end
        example '更新されず、edit_pageがレンダリングされること' do
          expect(article.reload.content).not_to be_empty
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
        end
      end
    end
    
    describe '一般ユーザーでログインしている場合' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        patch admin_article_path(article.post_id)
      end
      example 'エラーメッセージが表示されてadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていない時' do
      before do
        patch admin_article_path(article.post_id)
      end
      example '新規作成されずadmin_login_pathにリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
