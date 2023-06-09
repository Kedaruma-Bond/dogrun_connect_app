class TogoInuShitsukeHiroba::EmbedsController < TogoInuShitsukeHiroba::DogrunPlaceController
  include PostConcern
  before_action :set_new_post, only: %i[new]
  before_action :set_staffs, only: %i[create]

  def new
    @embed = Embed.new
    post = Post.find(params[:id])
    if !post.embed? || post.user != current_user || post.dogrun_place != @dogrun_place
      redirect_to send(@top_path), error: t('defaults.illegal_route')
    end
  end

  def create
    @embed = Embed.new(embed_params)
    if @embed.save
      send_notification_mail(@staffs)
      redirect_to send(@top_path), success: t('defaults.post_successfully')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def embed_params
      params.require(:embed).permit(
        :embed_type, :identifier
      ).merge(post_id: params[:id])
    end
  
end
