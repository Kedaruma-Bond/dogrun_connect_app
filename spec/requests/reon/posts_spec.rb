require 'rails_helper'

RSpec.describe Reon::PostsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }

  describe 'POST #create' do
    let!(:guest) { create(:user, :guest) }

    describe 'ログインしている時' do
      before do
        reon_log_in_as(general)
      end

      context 'post_type: "article"で作成した場合' do
        example 'postが作成され、適切なpathにリダイレクトされること' do
          expect {
            post reon_posts_path, 
            params: { 
              post: { post_type: 'article' } 
            }
          }.to change(Post, :count).by(1)
          post = Post.last
          expect(response).to redirect_to(new_reon_article_path(post))
          expect(flash[:notice]).to eq(I18n.t('local.posts.create_article'))
        end
      end

      context 'post_type: "embed"で作成した場合' do
        example 'postが作成され、適切なpathにリダイレクトされること' do
          expect {
            post reon_posts_path, 
            params: { 
              post: { post_type: 'embed' } 
            }
          }.to change(Post, :count).by(1)
          post = Post.last
          expect(response).to redirect_to(new_reon_embed_path(post))
          expect(flash[:notice]).to eq(I18n.t('local.posts.choice_sns'))
        end
      end

      context 'post_type: ""で作成した場合' do
        example 'postが作成されず、直前の表示画面にリダイレクトエラーメッセージが表示されること' do
        expect {
          post reon_posts_path, headers: { 'HTTP_REFERER' => '/reon/top' },
          params: {
            post: {
              post_type: ""
            }
          } 
        }.not_to change(Post, :count)
        expect(response).to redirect_to('/reon/top')
        expect(flash[:error]).to eq(I18n.t('local.posts.post_save_error'))
        end
      end
    end
    
    describe '凍結されたアカウントでログインしているとき' do
      before do
        reon_log_in_as(general)
        general.update(deactivation: 'account_frozen')
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect {
          post reon_posts_path, headers: { 'HTTP_REFERER' => '/reon/top' },
          params: {
            post: {
              post_type: 'article'
            }
          } 
        }.not_to change(Post, :count)
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ゲストログインしている時' do
      before do
        reon_log_in_as(guest)
      end

      example '直前の表示画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          post reon_posts_path, headers: { 'HTTP_REFERER' => '/reon/top' },
          params: {
            post: {
              post_type: 'article'
            }
          } 
        }.not_to change(Post, :count)
        expect(response).to redirect_to('/reon/top')
        expect(flash[:error]).to eq(I18n.t('local.posts.guest_cannot_create_post'))
      end
    end

    describe 'ログインしていない時' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        expect {
          post reon_posts_path
        }.not_to change(Post, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
