class TogoInuShitsukeHiroba::PostsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_staffs, :post_params, only: :create

  def new
    @post = Post.new
    @staffs = Staff.enable
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      unless @staffs.blank? then
        PostMailer.post_notification(@staffs).deliver_now
      end
      session.delete(:post)
      redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.success')
    end
  end

  private
    def post_params
      params.require(:post).permit(
        :content, :attach_image, :publish_status
      ).merge(user_id: current_user.id, dogrun_place_id: 2 )
    end

    def set_staffs
      @staffs = Staff.where(dogrun_place_id: 2).where(enable_notification: true)
    end
end
