require 'rails_helper'

RSpec.describe Admin::PostsController, type: :request do
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:admin_1) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: general) }
  let!(:dog_2) { create(:dog, :castrated, :public_view, user: general) }
  let!(:post_1) { create(:post, :article, user: general, dogrun_place: dogrun_place_1) }
  let!(:article) { create(:article, post: post_1) }
  let!(:post_2) { create(:post, :embed, user: general, dogrun_place: dogrun_place_2) }
  let!(:embed) { create(:embed, :twitter, post: post_2, ) }

  describe 'GET #index' do
    let!(:post_3) { create(:post, :article, user: general, dogrun_place: dogrun_place_1) }
    let!(:post_4) { create(:post, :embed, user: general, dogrun_place: dogrun_place_1) }

    context '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      
      example '正常なレスポンスが返り、不要な投稿が削除され正しい投稿が表示されること' do
        get admin_posts_path
        expect(response).to be_successful
        expect(response).to render_template(:index)
        expect(assigns(:posts)).to include(post_1)
      end
      
      example '不要な投稿が削除されること' do
        expect { 
          get admin_posts_path
        }.to change { Post.count }.by(-2)
        expect(assigns(:posts)).not_to include(post_3)
        expect(assigns(:posts)).not_to include(post_4)
      end

      example '別のドッグランへの投稿削除された投稿が表示されないこと' do
        get admin_posts_path
        expect(assigns(:posts)).not_to include(post_2)
      end
    end

    context '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        get admin_posts_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end

    context '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
        get admin_posts_path
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get admin_posts_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'GET #dogrun_board' do
    describe '管理者ユーザーでログインしているとき' do
      before do
        admin_log_in_as(admin_1)
        get dogrun_board_admin_posts_path
      end

      example '正常なレスポンスが帰ること' do
        expect(response).to be_successful
        expect(response).to render_template(:dogrun_board)
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        get dogrun_board_admin_posts_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
        get dogrun_board_admin_posts_path
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get dogrun_board_admin_posts_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'POST #create' do
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }

      describe '正しいパラメータが入力されている場合' do
        context 'post_typeがarticleのとき' do
          let(:article_post_params) { attributes_for(:post, :article)}
          example 'postが新規作成されてarticleの新規作成ページにリダイレクトされること' do
            expect { 
              post admin_posts_path, params: { post: article_post_params }
            }.to change(Post, :count).by(1)
            expect(response).to redirect_to(new_admin_article_path(Post.last))
            expect(flash[:notice]).to eq(I18n.t('local.posts.create_article'))
          end
        end

        context 'post_typeがembedのとき' do
          let(:embed_post_params) { attributes_for(:post, :embed)}
          example 'postが新規作成されembedの新規作成ページにリダイレクトされること' do
            expect { 
              post admin_posts_path, params: { post: embed_post_params }
            }.to change(Post, :count).by(1) 
            expect(response).to redirect_to(new_admin_embed_path(Post.last))
            expect(flash[:notice]).to eq(I18n.t('local.posts.choice_sns'))
          end
        end
      end
      
      context '不正なパラメータが入力されている場合' do
        let(:invalid_params) { attributes_for(:post, post_type: nil) }
  
        example '新規作成されないこと' do
          expect {
            post admin_posts_path, params: { post: invalid_params }
          }.not_to change(Post, :count)
          expect(response).to redirect_to(request.referer)
          expect(flash[:error]).to eq(I18n.t('local.posts.post_save_error'))
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        post admin_posts_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) } 
      
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        post admin_posts_path
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        post admin_posts_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'ログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '管理ドッグランに紐づいたpostを削除する場合' do
        example '正常にpostが削除されること' do
          expect {
            delete admin_post_path(post_1)
          }.to change(Post, :count).by(-1)
          expect(response).to redirect_to(admin_posts_path)
          expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
        end
      end

      context '別のドッグランに紐づいたpostを削除する場合' do
        example '削除されないこと' do
          expect {
            delete admin_post_path(post_2)
          }.not_to change(Post, :count)
          expect(response).to redirect_to(admin_root_path)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect {
          delete admin_post_path(post_1)
        }.not_to change(Post, :count)
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before { admin_log_in_as(general) } 
      
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect {
          delete admin_post_path(post_1)
        }.not_to change(Post, :count)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        expect {
          delete admin_post_path(post_1)
        }.not_to change(Post, :count)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'GET #set_publish_limit' do
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }
      context '管理ドッグランに紐づいたpostの掲示期限を設定する場合' do
        example 'acknolegeがtrueとなること' do
          get set_publish_limit_admin_post_path(post_1)
          expect(post_1.reload.acknowledge).to be_truthy
        end
      end

      context '別のドッグランに紐づいたpostの掲示期限を設定する場合' do
        example 'エラーメッセージが表示され管理者home画面にリダイレクトされること' do
          get set_publish_limit_admin_post_path(post_2)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        get set_publish_limit_admin_post_path(post_1)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーログインしているとき' do
      before { admin_log_in_as(general) } 
      
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        get set_publish_limit_admin_post_path(post_1)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get set_publish_limit_admin_post_path(post_1)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
  
  describe 'PATCH #start_to_publish' do
    describe '管理者ユーザーでログインしているとき' do
      before do
        admin_log_in_as(admin_1)
        allow(PostMailer).to receive(:publish_notification).and_return(double(deliver_now: true))
      end

      describe '管理ドッグランに紐づいたpostを更新するとき' do
        context '正しいパラメータが入力された場合' do
          let!(:limit_time) { Time.current.floor + 1.hour }
          let!(:post_5) { create(:post, :article, :is_publishing, user: general, dogrun_place: dogrun_place_1) }
          let!(:valid_params) { attributes_for(:post, publish_status: 'is_publishing', publish_limit: limit_time) }
          before { patch start_to_publish_admin_post_path(post_1), params: { post: valid_params } }
          
          example '掲載中のpostの掲載が中止され、該当postが掲載中になること' do
            expect(post_1.reload.publish_status).to eq('is_publishing')
            expect(post_5.reload.publish_status).to eq('non_publish')
          end
    
          example 'post作成者が一般ユーザーの場合通知メールを送信すること' do
            expect(PostMailer).to have_received(:publish_notification).with(post_1.user, dogrun_place_1, limit_time)
          end
    
          example '投稿一覧画面にリダイレクトされメッセージが表示されること' do
            expect(response).to redirect_to(admin_posts_path)
            expect(flash[:success]).to eq(I18n.t('admin.posts.start_to_publish.change_to_be_publishing'))
          end
        end
  
        context '不正なパラメータが入力された場合' do
          let!(:invalid_params) { attributes_for(:post, publish_status: nil) }
          before { patch start_to_publish_admin_post_path(post_1), params: { post: invalid_params } }
    
          example '投稿期間設定画面がレンダリングされること' do
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response).to render_template(:set_publish_limit)
          end
        end
      end

      describe '別のドッグランに紐づいたpostを更新するとき' do
        example '更新されないこと' do
          patch start_to_publish_admin_post_path(post_2)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        patch start_to_publish_admin_post_path(post_1)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
        patch start_to_publish_admin_post_path(post_1)
      end
      
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        patch start_to_publish_admin_post_path(post_1)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'PATCH #cancel_to_publish' do
    let!(:post_6) { create(:post, :article, :is_publishing, user: general, dogrun_place: dogrun_place_1) }
    let!(:post_7) { create(:post, :article, :is_publishing, user: general, dogrun_place: dogrun_place_2) }
    describe '管理者ユーザーでログインしているとき' do
      before do
        admin_log_in_as(admin_1)
      end
      describe '管理ドッグランに紐づいたpostの更新する場合' do
        example '掲載中の該当postが掲載が中止されメッセージが表示されること' do
          patch cancel_to_publish_admin_post_path(post_6)
          expect(post_6.reload.publish_status).to eq('non_publish')
          expect(flash[:success]).to eq(I18n.t('admin.posts.cancel_to_publish.change_to_non_publish'))
        end
      end

      describe '別のドッグランに紐づいたpostの更新をする場合' do
        example 'エラーメッセージが表示され管理者home画面にリダイレクトされること' do
          patch cancel_to_publish_admin_post_path(post_7)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        patch cancel_to_publish_admin_post_path(post_6)
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
        patch cancel_to_publish_admin_post_path(post_6)
      end
      
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        patch cancel_to_publish_admin_post_path(post_6)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'GET #search' do
    describe '管理者ユーザーでログインしているとき' do
      before { admin_log_in_as(admin_1) }

      example '正常なレスポンスがかえり正しい投稿が表示されること' do
        get search_admin_posts_path
        expect(response).to have_http_status(:success)
        expect(assigns(:posts)).to include(post_1)
      end
    end

    describe '凍結された管理者アカウントでログインしている場合' do
      before do
        admin_log_in_as(admin_1)
        admin_1.update(deactivation: 'account_frozen')
        get search_admin_posts_path
      end

      example 'ログアウトしてエラーメッセージが表示されroot_pathにリダイレクトされること' do
        expect(is_logged_in?).to eq(false)
        expect(flash[:error]).to eq(I18n.t('defaults.your_account_is_deactivating'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
        get search_admin_posts_path
      end
      
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
  
    describe 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        get search_admin_posts_path
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
