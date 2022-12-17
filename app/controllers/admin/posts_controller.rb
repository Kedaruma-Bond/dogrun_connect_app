class Admin::PostsController < Admin::BaseController
  include Pagy::Backend
  before_action :set_q, only: %i[index search]
  before_action :post_params, only: %i[create]
  before_action :post_params_for_publish, only: %i[start_to_publish]
  before_action :set_post, only: %i[destroy set_publish_limit start_to_publish cancel_to_publish]

  def index
    @publishing_post = Post.is_publishing

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

  def create
    @post = Post.new(post_params)
    if @post.save
      case @post.post_type
      when 'article'
        redirect_to new_admin_article_path(@post), notice: t('defaults.create_article')
      when 'embed'
        redirect_to new_admin_embed_path(@post), notice: t('defaults.choice_sns')
      end
      return
    else
      redirect_to admin_posts_path, error: t('defautls.post_save_error') and return
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to admin_posts_path, success: t('defaults.destroy_successfully'), status: :see_other }
      format.json { head :no_content }
    end
  end

  def set_publish_limit; end

  def start_to_publish
    publishing_post = Post.where(publish_status: 'is_publishing')
    publishing_post.update!(publish_status: 'non_publish')
    @post.update!(post_params_for_publish)
    if !@post.user.admin?
      PostMailer.publish_notification(@post.user, DogrunPlace.find(current_user.dogrun_place_id)).deliver_now
    end
    respond_to do |format|
      format.html { redirect_back_or_to admin_posts_path, success: t('.change_to_be_publishing') }
      format.json { head :no_content }
    end
  end

  def cancel_to_publish
    @post.update!(publish_status: 'non_publish')
    respond_to do |format|
      format.html { redirect_back_or_to admin_posts_path, success: t('.change_to_non_publish')}
      format.json { head :no_content }
    end
  end

  def search 
    @publishing_post = Post.is_publishing
    @pagy, @posts_results = pagy(@q.result)
  end

  private

    def set_q
      @posts = Post.where(dogrun_place_id: current_user.dogrun_place_id).includes([:user, :article, :embed]).order(created_at: :desc)
      @q = @posts.ransack(params[:q])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.permit(
        :post_type, :publish_status, :publish_limit
      ).merge(user_id: current_user.id, dogrun_place_id: current_user.dogrun_place_id)
    end

    def post_params_for_publish
      params.permit(
        :publish_status, :publish_limit
      )
    end
end
