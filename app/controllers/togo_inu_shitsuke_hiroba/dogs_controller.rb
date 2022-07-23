class TogoInuShitsukeHiroba::DogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  layout 'togo_inu_shitsuke_hiroba'
  before_action :dog_params, only: %i[update]

  def show; end

  def edit; end

  def update; end

  private

  def dog_params
    params.require(:dog).permit(
    ).merge()
  end
end
