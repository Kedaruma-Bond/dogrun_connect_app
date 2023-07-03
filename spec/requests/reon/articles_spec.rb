require 'rails_helper'

RSpec.describe Reon::ArticlesController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:dogrun_place_other) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }
  let!(:other) { create(:user, :general) }
  let!(:post_embed) { create(:post, :non_publish, :embed, user: general, dogrun_place: dogrun_place) }
  let!(:post_article) { create(:post, :non_publish, :article, user: general, dogrun_place: dogrun_place) }
  let!(:post_article_other_user) { create(:post, :non_publish, :article, user: other, dogrun_place: dogrun_place) }
  let!(:post_article_other_dogrun) { create(:post, :non_publish, :article, user: general, dogrun_place: dogrun_place_other) }
  
  describe 'GET #new' do
    describe 'ログインしているとき' do
      before do
        reon_log_in_as(general)
      end
      
      context 'postのtypeがarticleでない場合' do
        example 'dogrunのtop pageにリダイレクトされること' do
          get new_reon_article_path(id: post_embed.id)
      
          expect(response).to redirect_to(reon_top_path)
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
        end
      end
      
      context 'postのuserがcurrent_userでない場合' do
        example 'dogrunのtop pageにリダイレクトされること' do
          get new_reon_article_path(id: post_article_other_user.id)
      
          expect(response).to redirect_to(reon_top_path)
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
        end
      end
      
      context 'postのdogrun_placeが正しくない場合' do
        example 'dogrunのtop pageにリダイレクトされること' do
          get new_reon_article_path(id: post_article_other_dogrun.id)
      
          expect(response).to redirect_to(reon_top_path)
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
        end
      end
  
  
      context 'postのtypeがarticleでuserとdogrun_placeが正しい場合' do
        example '正常にレンダリングされること' do
          get new_reon_article_path(id: post_article.id)
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:ok)
          expect(assigns(:article)).to be_a_new(Article)
        end
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get new_reon_article_path(id: post_article.id)
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

      context '入力されたパラメータが正常な場合' do
        example '新規作成されるドッグランのtopにリダイレクトされること' do
          expect {
            post reon_article_path(post_article),
            params: {
              article: {
                content: "test_content"
              }
            }
          }.to change(Article, :count).by(1)
          expect(response).to redirect_to(reon_top_path)
          expect(flash[:success]).to eq(I18n.t('defaults.post_successfully'))
        end
      end
  
      context '入力されたパラメータが不正な場合' do
        example '新規作成されず、newがレンダリングされること' do
          expect {
            post reon_article_path(post_article),
            params: {
              article: {
                content: ""
              }
            }
          }.not_to change(Article, :count)
  
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:article).errors).to be_of_kind(:content, :blank)
        end
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post reon_article_path(post_article)

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
