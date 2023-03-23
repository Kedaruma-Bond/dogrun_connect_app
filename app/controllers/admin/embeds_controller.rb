class Admin::EmbedsController < Admin::BaseController
  before_action :set_embed, only: %i[edit update]
  before_action :correct_admin_check, only: %i[edit update]

  def new
    @embed = Embed.new
    post = Post.find(params[:id])
    if !post.embed?
      redirect_to admin_posts_path, error: t('defaults.illegal_route')
    end
  end

  def create
    @embed = Embed.new(embed_params)
    if @embed.save
      redirect_to admin_posts_path, success: t('defaults.post_successfully')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    session[:previous_url] = request.referer
  end

  def update
    if @embed.update(embed_params)
      if session[:previous_url].nil?
        redirect_to admin_posts_path, success: t('defaults.update_successfully')
      else
        redirect_to session[:previous_url], success: t('defaults.update_successfully')
      end
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

    def correct_admin_check
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin? ||  @embed.post.dogrun_place == current_user.dogrun_place
    end
end
