class TogoInuShitsukeHiroba::EncountDogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  include Pagy::Backend
  before_action :set_encount_dogs, only: %i[index search]
  before_action :set_q, only: %i[index search]
  before_action :correct_user_check, only: %i[edit update destroy]
  
  def index
    @pagy, @encount_dogs = pagy(EncountDog.encount_dog_of_user(current_user.id), link_extra: 'data-turbo-stream="true" data-controller="autoclick"')
  end

  def edit
    @encount_dog.update!(acknowledge: true)
    session[:previous_url] = request.referer
  end

  def update
    if @encount_dog.update(encount_dog_params)
      respond_to do |format|
        format.html {
          if session[:previous_url].nil?
            redirect_to send(@encount_dogs_path), success: t('local.encount_dogs.encount_dog_updated')
          else
            redirect_to session[:previous_url],success: t('local.encount_dogs.encount_dog_updated') 
          end
        }
        format.turbo_stream { flash.now[:success] = t('local.encount_dogs.encount_dog_updated')}
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @pagy, @encount_dogs_results = pagy(@q.result, link_extra: 'data-turbo-stream="true" data-controller="autoclick"')
  end

  def destroy
    @encount_dog.destroy
    respond_to do |format|
      format.html { redirect_to send(@encount_dogs_path), success: t('defaults.destroy_successfully') }
      format.turbo_stream { flash.now[:success] = t('defaults.destroy_successfully') }
    end
  end

  private

    def set_encount_dogs
      @encount_dogs = EncountDog.encount_dog_of_user(current_user.id)
    end

    def set_q
      @q = @encount_dogs.ransack(params[:q])
    end

    def encount_dog_params
      params.require(:encount_dog).permit(
        :color_marker, :memo
      )
    end

    def correct_user_check
      @encount_dog = EncountDog.find(params[:id])
      redirect_to send(@encount_dogs_path), error: t('defaults.not_authorized') unless @encount_dog.user == current_user
    end
end
