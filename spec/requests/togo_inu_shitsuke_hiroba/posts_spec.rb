require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::PostsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:general) { create(:user, :general) }

  describe 'POST #create' do
    let!(:guest) { create(:user, :guest) }

    describe 'ゲストログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(guest)
      end

      example '直前の表示画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          post togo_inu_shitsuke_hiroba_posts_path, headers: { 'HTTP_REFERER' => '/togo_inu_shitsuke_hiroba/top' },
          params: {
            post: {
              post_type: 'article'
            }
          } 
        }.not_to change(Post, :count)
        expect(response).to redirect_to('/togo_inu_shitsuke_hiroba/top')
        expect(flash[:error]).to eq(I18n.t('local.posts.guest_cannot_create_post'))
      end
    end

    describe 'ログインしている時' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      context 'post_type: "article"で作成した場合' do
        example 'postが作成され、適切なpathにリダイレクトされること' do
          expect {
            post togo_inu_shitsuke_hiroba_posts_path, 
            params: { 
              post: { post_type: 'article' } 
            }
          }.to change(Post, :count).by(1)
          post = Post.last
          expect(response).to redirect_to(new_togo_inu_shitsuke_hiroba_article_path(post))
          expect(flash[:notice]).to eq(I18n.t('local.posts.create_article'))
        end
      end

      context 'post_type: "embed"で作成した場合' do
        example 'postが作成され、適切なpathにリダイレクトされること' do
          expect {
            post togo_inu_shitsuke_hiroba_posts_path, 
            params: { 
              post: { post_type: 'embed' } 
            }
          }.to change(Post, :count).by(1)
          post = Post.last
          expect(response).to redirect_to(new_togo_inu_shitsuke_hiroba_embed_path(post))
          expect(flash[:notice]).to eq(I18n.t('local.posts.choice_sns'))
        end
      end

      context 'post_type: ""で作成した場合' do
        example 'postが作成されず、直前の表示画面にリダイレクトエラーメッセージが表示されること' do
        expect {
          post togo_inu_shitsuke_hiroba_posts_path, headers: { 'HTTP_REFERER' => '/togo_inu_shitsuke_hiroba/top' },
          params: {
            post: {
              post_type: ""
            }
          } 
        }.not_to change(Post, :count)
        expect(response).to redirect_to('/togo_inu_shitsuke_hiroba/top')
        expect(flash[:error]).to eq(I18n.t('local.posts.post_save_error'))
        end
      end
    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          post togo_inu_shitsuke_hiroba_posts_path
        }.not_to change(Post, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
