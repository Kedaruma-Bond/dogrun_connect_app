class Admin::EmbedsController < Admin::BaseController
  before_action :set_embed, only: %i[edit update]
  before_action :embed_params, only: %i[create update]

  def new
    @embed = Embed.new
  end

  def create
    @embed = Embed.new(embed_params)
    if @embed.save
      redirect_to admin_posts_path, success: t('defaults.post_successfully')
      return
    end
    render :new, status: :unprocessable_entity
  end

  def edit; end

  def update
    if @embed.valid?
      @embed.update(embed_params)
      redirect_to admin_posts_path, success: t('defaults.update_successfully')
      return
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  
    def embed_params
      params.require(:embed).permit(
        :embed_type, :identifier
      ).merge(post_id: params[:id])
    end

    def set_embed
      @embed = Embed.find_by(post_id: params[:id])
    end
end