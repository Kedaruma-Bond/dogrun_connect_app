class Admin::StaffsController < Admin::BaseController
  before_action :set_posts, only: %i[index]
  before_action :post_params, only: %i[create]
  before_action :set_post, only: %i[edit update destroy start_to_publish cancel_to_be_publish]

  def index; end

  def create
  end

  def edit; end

  def update
    
  end

  def destroy
  end

  def start_to_publish
  end

  def cancel_to_be_publish
  end

  private

    def set_posts
      @posts = Post.where(dogrun_place_id: current_user.dogrun_place_id).order(created_at: :desc).page(params[:page])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
    end
end
