require 'rails_helper'

RSpec.describe TogoInuShitsukeHiroba::EmbedsController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_other) { create(:dogrun_place, :reon) }
  let!(:general) { create(:user, :general) }
  let!(:other) { create(:user, :general) }
  let!(:post_article) { create(:post, :article, user: general, dogrun_place: dogrun_place) }
  let!(:post_embed) { create(:post, :embed, user: general, dogrun_place: dogrun_place) }
  let!(:post_embed_other_user) { create(:post, :embed, user: other, dogrun_place: dogrun_place) }
  let!(:post_embed_other_dogrun) { create(:post, :embed, user: general, dogrun_place: dogrun_place_other) }

  describe 'GET #new' do
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end
      
      context 'postのtypeがembedでない場合' do
        example 'dogrunのtop pageにリダイレクトされること' do
          get new_togo_inu_shitsuke_hiroba_embed_path(id: post_article.id)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
        end
      end
      
      context 'postのuserがcurrent_userでない場合' do
        example 'dogrunのtop pageにリダイレクトされること' do
          get new_togo_inu_shitsuke_hiroba_embed_path(id: post_embed_other_user.id)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
        end
      end
      
      context 'postのdogrun_placeが正しくない場合' do
        example 'dogrunのtop pageにリダイレクトされること' do
          get new_togo_inu_shitsuke_hiroba_embed_path(id: post_embed_other_dogrun.id)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
          expect(flash[:error]).to eq(I18n.t('defaults.illegal_route'))
        end
      end

      context 'postのtypeがembedでuserとdogrun_placeが正しいとき' do
        example '正常なレスポンスが変えること' do
          get new_togo_inu_shitsuke_hiroba_embed_path(id: post_embed.id)
          expect(response).to be_successful
        end
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        get new_togo_inu_shitsuke_hiroba_embed_path(id: post_embed.id)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        get new_togo_inu_shitsuke_hiroba_embed_path(id: post_embed.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end

  describe 'POST #create' do
    let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place) }
    describe 'ログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
      end

      context '入力されたパラメータが正常な場合' do
        example '新規作成されること' do
          expect {
            post togo_inu_shitsuke_hiroba_embed_path(post_embed),
            params: {
              embed: {
                embed_type: "twitter",
                identifier: "https://twitter.com/DogrunConnect/status/1583012384200794113?s=20&t=OTM9nq2MhK7DaBDynfn5GQ"
              }
            }
          }.to change(Embed, :count).by(1)
          expect(response).to redirect_to(togo_inu_shitsuke_hiroba_top_path)
          expect(flash[:success]).to eq(I18n.t('defaults.post_successfully'))
        end
      end
  
      context '入力されたパラメータが不正な場合' do
        example '新規作成されず、new templateがレンダリングされること' do
          expect {
            post togo_inu_shitsuke_hiroba_embed_path(post_embed), 
            params: { 
              embed: { 
                embed_type: "",
                identifier: ""
              }
            }
          }.not_to change(Embed, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(assigns(:embed).errors).to be_of_kind(:embed_type, :blank)
          expect(assigns(:embed).errors).to be_of_kind(:identifier, :blank)
        end
      end
    end

    describe '凍結されたアカウントでログインしているとき' do
      before do
        togo_inu_shitsuke_hiroba_log_in_as(general)
        general.update(deactivation: 'account_frozen')
        post togo_inu_shitsuke_hiroba_embed_path(post_embed) 
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'root画面にリダイレクトされエラーメッセージが表示されること' do
        post togo_inu_shitsuke_hiroba_embed_path(post_embed) 
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
      end
    end
  end
end
