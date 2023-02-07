class TogoInuShitsukeHiroba::PostsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :post_params, only: :create

  def create
    @post = Post.new(post_params)
    if @post.save
      case @post.post_type
      when 'article'
        redirect_to new_togo_inu_shitsuke_hiroba_article_path(@post), notice: t('defaults.create_article')
      when 'embed'
        redirect_to new_togo_inu_shitsuke_hiroba_embed_path(@post), notice: t('defaults.choice_sns')
      end
      return
    else
      redirect_to request.referer, error: t('defaults.post_save_error') 
    end
  end

  private
    def post_params
      params.permit(
        :post_type, :dogrun_place_id, :publish_status
      ).merge(user_id: current_user.id)
    end
end
