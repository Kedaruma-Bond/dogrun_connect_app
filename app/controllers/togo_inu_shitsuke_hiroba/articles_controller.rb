class TogoInuShitsukeHiroba::ArticlesController < TogoInuShitsukeHiroba::DogrunPlaceController
  include PostConcern
  before_action :set_staffs, only: %i[create]
  before_action :article_params, only: %i[create]
  
  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      send_notification_mail(@staffs)
      redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('defaults.success_to_post')
      return  
    end
    render :new, status: :unprocessable_entity
  end

  private
    def article_params
      params.require(:article).permit(
        :content, :image_attach
      ).merge(post_id: params[:id])
    end
    
end
