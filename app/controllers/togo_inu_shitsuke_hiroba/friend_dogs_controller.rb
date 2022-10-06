class TogoInuShitsukeHiroba::FriendDogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  
  def index
    @friend_dogs = FriendDog.
  end

  def update

  end

  private

    def friend_dog_params
      params.require(:friend_dog).permit(
        :color_marker, :memo
      )
    end

end
