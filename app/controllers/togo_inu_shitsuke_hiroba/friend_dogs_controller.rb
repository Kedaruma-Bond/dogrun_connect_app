class TogoInuShitsukeHiroba::FriendDogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_friend_dogs, only: %i[index search]
  before_action :set_q, only: %i[index search]
  before_action :set_friend_dog, only: %i[edit update]
  
  def index; end

  def edit; end

  def update

  end

  def search
    @friend_dogs_results = @q.result.page(params[:page])
  end

  private

    def set_friend_dogs
      friend_dogs_distinct_data_first = FriendDog.where(user_id: current_user.id).joins(:dog).group(:dog_id).having('count(*) >= 1').minimum(:id)
      @friend_dogs = FriendDog.where(dog_id: friend_dogs_distinct_data_first.keys).where(id: friend_dogs_distinct_data_first.values).page(params[:page])
    end

    def set_q
      @q = @friend_dogs.ransack(params[:q])
    end

    def set_friend_dog
      @friend_dog = FriendDog.find(params[:id])
    end

    def friend_dog_params
      params.require(:friend_dog).permit(
        :color_marker, :memo
      )
    end

end
