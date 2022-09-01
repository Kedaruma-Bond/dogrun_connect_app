class Admin::DogsController < Admin::BaseController
  before_action :set_dogs, only: %i[index search]
  before_action :set_q, only: %i[index search]

  def index; end

  def search
    @dogs_results = @q.result.page(params[:page])
  end

  private

    def set_dogs
      @dogs = Dog.dogrun_place_id(current_user.dogrun_place_id).page(params[:page])
    end

    def set_q
      @q = @dogs.ransack(params[:q])
    end

end
