class Admin::DogsController < Admin::BaseController
  before_action :set_dogs, only: %i[index search]
  before_action :set_dog, only: %i[edit update]
  before_action :dog_params, only: %i[update]
  before_action :set_q, only: %i[index search]
  around_action :skip_bullet, if: -> { defined?(Bullet) } 


  def index; end

  def edit; end

  def update
    if @dog.valid?
      @dog.update(dog_params)
      redirect_to admin_dogs_path, success: t('defaults.update_successfully')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @dogs_results = @q.result.page(params[:page])
  end

  private

    def dog_params
      params.require(:dog).permit(
        :thumbnail, :name, :breed, :castration,
        :public, :owner_comment, :sex, :weight, :birthday
      )
    end

    def set_dogs
      case current_user.name
      when "grand_admin"
        @dogs = Dog.includes([:user], [:thumbnail_attachment]).with_attached_thumbnail.page(params[:page])
      else
        @dogs = Dog.dogrun_place_id(current_user.dogrun_place_id).page(params[:page])
      end
    end

    def set_dog
      @dog = Dog.find(params[:id])
    end

    def set_q
      @q = @dogs.ransack(params[:q])
    end

end
