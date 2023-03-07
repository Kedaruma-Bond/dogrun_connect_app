class Reon::ArticlesController < Reon::DogrunPlaceController
  include PostConcern
  before_action :set_staffs, only: %i[create]
  before_action :article_params, only: %i[create]
  
  def new
    @article = Article.new
    post = Post.find(params[:id])
    if !post.article?
      redirect_to send(@top_path), error: t('defaults.illegal_route')
    end
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      send_notification_mail(@staffs)
      redirect_to send(@top_path), success: t('defaults.post_successfully')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.require(:article).permit(
        :content, :photo
      ).merge(post_id: params[:id])
    end
    
end
