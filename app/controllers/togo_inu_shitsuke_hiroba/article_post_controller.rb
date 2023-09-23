class TogoInuShitsukeHiroba::ArticlePostController < TogoInuShitsukeHiroba::DogrunPlaceController
  include PostConcern
  before_action :check_not_guest
  before_action :set_staffs, only: %i[create]

  def new
    @article_post = ArticlePost.new
  end

  def create
    @article_post = ArticlePost.new(article_post_params)
    if @article_post.valid?
      @article_post.save
      send_notification_mail(@staffs)
      respond_to do |format|
        format.html { 
          redirect_to send(@top_path), success: t('defaults.post_successfully')
        }
        format.turbo_stream {
          flash.now[:success] = t('defaults.post_successfully')
        }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def article_post_params
      params.require(:article_post).permit(
        :post_type, :publish_status,
        :content, :photo
      ).merge(
        user_id: current_user.id,
        dogrun_place_id: @dogrun_place.id
      )
    end
end
