class TogoInuShitsukeHiroba::PostsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :post_params, only: %i[create]

  def create
    @post = Post.new(post_params)

    if @post.invalid?
      return head :bad_request
    end

    postable_type = params.dig(:post, :postable_type)

    if postable_type.blank? || !Post.valid_postable_type?(postable_type)
      return head :bad_request
    end

    @post.create_postable!(postable_type)
    @post.save!

    case @post.postable_type
    when Article
      redirect_to new_togo_inu_shitsuke_hiroba_article_path, notice: t('.make_article')
      return
    when Embed
      redirect_to new_togo_inu_shitsuke_hiroba_embed_path, notice: t('.choice_sns')
      return
    else
      raise ActionController::ParameterMissing, :postable
    end
  end

  private
    def post_params
      params.require(:post).permit(
        :publish_status, :postable_type
      ).merge(user_id: current_user.id, dogrun_place_id: 2 )
    end
end
