class TogoInuShitsukeHiroba::EncountDogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_encount_dogs, only: %i[index search]
  before_action :set_q, only: %i[index search]
  before_action :set_encount_dog, only: %i[edit update]
  
  def index; end

  def edit
    @encount_dog.update!(acknowledge: true)
  end

  def update
    if @encount_dog.valid?
      @encount_dog.update(encount_dog_params)
      redirect_to togo_inu_shitsuke_hiroba_encount_dogs_path, success: t('.encount_dog_updated')
      return
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @encount_dogs_results = @q.result.page(params[:page])
  end

  private

    def set_encount_dogs
      @encount_dogs = EncountDog.joins(:dogrun_place, :dog).includes(dog: { thumbnail_attachment: :blob }).where(user_id: current_user.id).where(dogs: { public: 'public_view' }).order(created_at: :desc).page(params[:page])
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
