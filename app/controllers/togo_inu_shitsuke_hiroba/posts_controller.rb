class TogoInuShitsukeHiroba::PostsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_staffs, :post_params, only: :create

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      unless @staffs.blank? then
        n = 0
        @dogrun_place = DogrunPlace.find(@staffs[0].dogrun_place_id)
        @staffs.size.times do
          PostMailer.post_notification(@staffs[n], @dogrun_place).deliver_now
          n += 1
        end
      end
      session.delete(:post)
      redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.success')
    end
  end

  private
    def post_params
      params.require(:post).permit(
        :publish_status
      ).merge(user_id: current_user.id, dogrun_place_id: 2 )
    end

    def set_staffs
      @staffs = Staff.where(dogrun_place_id: 2).enable
    end
end
