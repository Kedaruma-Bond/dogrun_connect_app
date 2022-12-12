class TogoInuShitsukeHiroba::EncountDogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_encount_dogs, only: %i[index search]
  before_action :set_q, only: %i[index search]
  before_action :set_encount_dog, only: %i[edit update]
  
  def index; end

  def edit
    @encount_dog.update!(acknowledge: true)
  end

  def update
    if @encount_dog.update(encount_dog_params)
      redirect_to togo_inu_shitsuke_hiroba_encount_dogs_path, success: t('.encount_dog_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @encount_dogs_results = @q.result.page(params[:page])
  end

  private

    def set_encount_dogs
      @encount_dogs = EncountDog.encount_dog_of_user(current_user.id).page(params[:page])
      @encount_dogs_for_count = EncountDog.where(user: current_user)
    end

    def set_q
      @q = @encount_dogs.ransack(params[:q])
    end

    def set_encount_dog
      @encount_dog = EncountDog.find(params[:id])
    end

    def encount_dog_params
      params.require(:encount_dog).permit(
        :color_marker, :memo
      )
    end

end
