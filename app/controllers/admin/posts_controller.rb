class Admin::PostsController < Admin::BaseController
  include Pagy::Backend
  before_action :set_q, :set_new_post, only: %i[index search]
  before_action :set_dogrun_place, only: %i[index search start_to_publish cancel_to_publish dogrun_board destroy]
  before_action :set_post, only: %i[destroy set_publish_limit start_to_publish cancel_to_publish]
  before_action :correct_admin_check, only: %i[destroy set_publish_limit start_to_publish cancel_to_publish]

  def index
    @publishing_post = Post.is_publishing.where(dogrun_place: @dogrun_place)

    no_article_posts = @posts.where(post_type: 'article').where.missing(:article)
    no_article_posts.map do |post|
      post.delete
    end

    no_embeds_posts = @posts.where(post_type: 'embed').where.missing(:embed)
    no_embeds_posts.map do |post|
      post.delete
    end

    @pagy, @posts = pagy(@posts)
  end

  def dogrun_board
    @publishing_post = Post.is_publishing.where(dogrun_place: @dogrun_place)
    render template: "admin/posts/dogrun_board"
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      case @post.post_type
      when 'article'
        redirect_to new_admin_article_path(@post), notice: t('local.posts.create_article')
      when 'embed'
        redirect_to new_admin_embed_path(@post), notice: t('local.posts.choice_sns')
      end
      return
    else
      if request.referer.nil?
        redirect_to admin_posts_path, error: t('local.posts.post_save_error')
      else
        redirect_to request.referer, error: t('local.posts.post_save_error')
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { 
        if request.referer.nil?
          redirect_to admin_posts_path, success: t('defaults.destroy_successfully'), status: :see_other 
        else
          redirect_to request.referer, success: t('defaults.destroy_successfully'), status: :see_other 
        end
      }
      format.turbo_stream { flash.now[:success] = t('defaults.destroy_successfully') }
    end
    @post.destroy_broadcast
  end

  def set_publish_limit
    session[:previous_url] = request.referer
    @post.update!(acknowledge: true)
    @post.remove_new_badge
    
  end

  def start_to_publish
    @previous_published_post = Post.find_by(publish_status: 'is_publishing')
    if !@previous_published_post.nil?
      Post.where(publish_status: 'is_publishing').update!(publish_status: 'non_publish')
      @previous_published_post = Post.find(@previous_published_post.id)
    end
    if @post.update(post_params_for_publish)
      @publishing_post = Post.is_publishing.where(dogrun_place: @dogrun_place)
      if !@post.user.admin?
        PostMailer.publish_notification(@post.user, @dogrun_place).deliver_now
      end
      respond_to do |format|
        format.html { 
          if session[:previous_url].nil?
            redirect_to admin_posts_path, success: t('.change_to_be_publishing')
          else
            redirect_to session[:previous_url], success: t('.change_to_be_publishing') 
          end
        }
        format.turbo_stream { flash.now[:success] = t('.change_to_be_publishing') }
      end
    else
      render :set_publish_limit, status: :unprocessable_entity
    end
  end

  def cancel_to_publish
    @post.update(publish_status: 'non_publish')
    respond_to do |format|
      format.html { 
        if request.referer.nil?
          redirect_to admin_posts_path, success: t('.change_to_non_publish')
        else
          redirect_to request.referer, success: t('.change_to_non_publish')
        end
      }
      format.turbo_stream { flash.now[:success] = t('.change_to_non_publish') }
    end
  end

  def search 
    @publishing_post = Post.is_publishing
    @pagy, @posts_results = pagy(@q.result)
  end

  private

    def set_dogrun_place
      @dogrun_place = current_user.dogrun_place
    end

    def set_q
      @posts = Post.where(dogrun_place_id: current_user.dogrun_place_id).includes([:user, :article, :embed]).order(created_at: :desc)
      @q = @posts.ransack(params[:q])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(
        :post_type, :publish_status
      ).merge(user_id: current_user.id, dogrun_place_id: current_user.dogrun_place_id)
    end

    def post_params_for_publish
      params.require(:post).permit(
        :publish_status, :publish_limit
      )
    end

    def correct_admin_check
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin? ||  @post.dogrun_place == current_user.dogrun_place
    end
end
