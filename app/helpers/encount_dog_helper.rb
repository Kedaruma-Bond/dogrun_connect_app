module EncountDogHelper
  def new_encount_dog_count_badge
    current_user_new_encount_dogs = EncountDog.where(user_id: current_user.id).where(acknowledge: false)
    
    @current_user_new_encount_dogs_count = current_user_new_encount_dogs.count
  end

  def new_encount_dog_badge(encount_dog)
    
  end
end
