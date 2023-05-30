require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::ArticlesController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:post_embed) { create(:post, :non_publish, :embed) }
  let!(:post_article) { create(:post, :non_publish, :article) }
  
  describe 'GET #new' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end
      
      context 'postのtypeがarticleでない場合' do
        example 'dogrunのtop pageにリダイレクトされること' do
          get new_togo_inu_shitsuke_hiroba_article_path(id: post_embed.id)
      
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
        end
      end
  
  
      context 'postのtypeがarticleの場合' do
        example '正常にレンダリングされること' do
          get new_togo_inu_shitsuke_hiroba_article_path(id: post_article.id)
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:ok)
          expect(assigns(:article)).to be_a_new(Article)
        end
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get new_togo_inu_shitsuke_hiroba_article_path(id: post_article.id)
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

      context '入力されたパラメータが正常な場合' do
        example '新規作成されるドッグランのtopにリダイレクトされること' do
          expect {
            post togo_inu_shitsuke_hiroba_article_path(post_article),
            params: {
              article: {
                content: "test_content"
              }
            }
          }.to change(Article, :count).by(1)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
          expect(flash[:success]).to eq(I18n.t('defaults.post_successfully'))
        end
      end
  
      context '入力されたパラメータが不正な場合' do
        example '新規作成されず、newがレンダリングされること' do
          expect {
            post togo_inu_shitsuke_hiroba_article_path(post_article),
            params: {
              article: {
                content: ""
              }
            }
          }.not_to change(Article, :count)
  
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_article_path(post_article)

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
