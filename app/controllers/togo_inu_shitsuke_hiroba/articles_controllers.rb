class TogoInuShitsukeHiroba::ArticlesController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_staffs, only: %i[create]
  
  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      send_notification_mail(@staffs)
      redirect_to togo_inu_shitsuke_hiroba_top_, success: t('defaults.sccess_to_post')
      return  
    end
    render :new, status: :unprocessable_entity
  end

  private
    def article_params
      params.require(:article).permit(
        :content, :image_attach
      ).merge(pastable)
    end
end
