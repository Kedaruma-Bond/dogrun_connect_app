class Reon::PostsController < Reon::DogrunPlaceController

  def create
    if current_user.guest?
      redirect_to request.referer, error: t('local.posts.guest_cannot_create_post')
      return
    end
    @post = Post.new(post_params)
    if @post.save
      case @post.post_type
      when 'article'
        redirect_to send(@new_article_path, @post), notice: t('local.posts.create_article')
      when 'embed'
        redirect_to send(@new_embed_path, @post), notice: t('local.posts.choice_sns')
      end
      return
    else
      redirect_to request.referer, error: t('local.posts.post_save_error') 
    end
  end

  private
    def post_params
      params.require(:post).permit(
        :post_type, :publish_status
      ).merge(user_id: current_user.id, dogrun_place_id: @dogrun_place.id)
    end
end
