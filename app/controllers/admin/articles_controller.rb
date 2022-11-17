class Admin::ArticlesController < Admin::BaseController
  before_action :set_article, only: %i[edit update]
  before_action :article_params, only: %i[create update]

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to admin_posts_path, success: t('defaults.post_successfully')
      return
    end
    render :new, status: :unprocessable_entity
  end

  def edit; end

  def update
    if @article.valid?
      @article.update(article_params)
      redirect_to admin_posts_path, success: t('defaults.update_successfully')
      return
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
end
