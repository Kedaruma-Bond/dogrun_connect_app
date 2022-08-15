class Admin::DogrunPlacesController < Admin::BaseController
  before_action :dogrun_place_params, only: :create
  def index
    @dogrun_places = DogrunPlace.all
    @dogrun_place = DogrunPlace.new
  end

  def create
    @dogrun_place = DogrunPlace.new(dogrun_place_params)
    @dogrun_place.save!
    redirect_to admin_dogrun_places_path, success: t('.create_success')
  end

  private

  def dogrun_place_params
    params.require(:dogrun_place).permit(:name)
  end

end
