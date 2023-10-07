require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::ArticlePostController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:guest) { create(:user, :guest) }

  describe 'GET #new' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      example '正常なレスポンスがかえること' do
        get togo_inu_shitsuke_hiroba_article_post_path
        expect(response).to render_template(:new)
      end
    end

    describe '凍結されたアカウントログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get togo_inu_shitsuke_hiroba_article_post_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ゲストログインしているとき' do
      before do 
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end

      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_fully_registration_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get togo_inu_shitsuke_hiroba_dog_fully_registration_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'POST #create' do
    let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place) }
    let!(:staff) { create(:staff, :enable, dogrun_place: dogrun_place) }

    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      context 'パラメータが正しい場合' do
        example 'PostとArticleが作成されること' do
          expect {
            post togo_inu_shitsuke_hiroba_article_post_path,
            params: {
              article_post: {
                post_type: "article",
                publish_status: "non_publish",
                dogrun_place: dogrun_place,
                user: general,
                content: "test",
                photo: nil,
              }
            }
          }.to change(Post, :count).by(1).and change(Article, :count).by(1)
          
          expect {
            post togo_inu_shitsuke_hiroba_article_post_path,
            params: {
              article_post: {
                post_type: "article",
                publish_status: "non_publish",
                dogrun_place: dogrun_place,
                user: general,
                content: "test",
                photo: nil, 
              }
            }
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context 'パラメータが不正な場合' do
        example 'レコードは作成されずnew formがレンダリングされエラーメッセージが表示されること' do
          expect {
            post togo_inu_shitsuke_hiroba_article_post_path, 
            params: {
              article_post: {
                post_type: "article",
                publish_status: "non_publish",
                dogrun_place: dogrun_place,
                user: general,
                content: "",
                photo: nil, 
              }
            }
          }.not_to change(Post, :count)
          
          expect {
            post togo_inu_shitsuke_hiroba_article_post_path, 
            params: {
              article_post: {
                post_type: "article",
                publish_status: "non_publish",
                dogrun_place: dogrun_place,
                user: general,
                content: "",
                photo: nil, 
              }
            }
          }.not_to change(Article, :count)

          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:article_post).errors).to be_of_kind(:content, :blank)
        end
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        post togo_inu_shitsuke_hiroba_article_post_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ゲストログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end
      
      example 'signup画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_article_post_path
        expect(response).to redirect_to(togo_inu_shitsuke_hiroba_signup_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_signup'))
      end

    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_article_post_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
