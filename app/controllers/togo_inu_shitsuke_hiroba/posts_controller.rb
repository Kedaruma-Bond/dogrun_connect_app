class TogoInuShitsukeHiroba::PostsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :post_params, only: :create

  def create
    @post = Post.new(post_params)
    if @post.save
      case @post.post_type
      when 'article'
        redirect_to send(@new_article_path, @post), notice: t('local.posts.create_article')
      when 'embed'
        redirect_to send(@new_embed_path,@post), notice: t('local.posts.choice_sns')
      end
    else
      redirect_to request.referer, error: t('local.posts.post_save_error') 
    end
  end

  private
    def post_params
      params.permit(
        :post_type, :publish_status
      ).merge(user_id: current_user.id, dogrun_place_id: @dogrun_place.id)
    end
end
