class TogoInuShitsukeHiroba::FriendDogsController < TogoInuShitsukeHiroba::DogrunPlaceController
  
  def index
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
