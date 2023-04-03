class Admin::ArticlesController < Admin::BaseController
  before_action :set_article, only: %i[edit update]
  before_action :correct_admin_check, only: %i[edit update] 

  def new
    @article = Article.new
    post = Post.find(params[:id])
    if !post.article?
      redirect_to admin_posts_path, error: t('defaults.illegal_route')
    end
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to admin_posts_path, success: t('defaults.post_successfully')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    session[:previous_url] = request.referer
  end

  def update
    if @article.update(article_params)
      if session[:previous_url].nil?
        redirect_to admin_posts_path, success: t('defaults.update_successfully')
      else
        redirect_to session[:previous_url], success: t('defaults.update_successfully')
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def article_params
      params.require(:article).permit(
        :content, :photo
      ).merge(post_id: params[:id])
    end

    def set_article
      @article = Article.find_by(post_id: params[:id])
    end

    def correct_admin_check
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin? ||  @article.post.dogrun_place == current_user.dogrun_place
    end
end
