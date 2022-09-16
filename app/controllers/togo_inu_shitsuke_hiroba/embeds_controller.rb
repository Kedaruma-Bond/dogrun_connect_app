class TogoInuShitsukeHiroba::EmbedsController < TogoInuShitsukeHiroba::DogrunPlaceController
  include PostConcern
  before_action :set_staffs, only: %i[create]
  before_action :embed_params, only: %i[create]

  def new
    @embed = Embed.new
  end

  def create
    @embed = Embed.new(embed_params)
    if @embed.save
      send_notification_mail(@staffs)
      redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('defaults.success_to_post')
      return
    end
    render :new, status: :unprocessable_entity
  end

  private
    def embed_params
      params.require(:embed).permit(
        :embed_type, :identifier
      ).merge(post_id: params[:id])
    end
  
end
