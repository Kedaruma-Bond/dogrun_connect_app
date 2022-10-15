module EncountDogHelper
  def new_encount_dog_count_badge
    current_user_new_encount_dogs = EncountDog.where(user_id: current_user.id).where(acknowledge: false)
    current_user_new_encount_dogs_count = current_user_new_encount_dogs.count
    if current_user_new_encount_dogs_count == 0
      return
    else
      return tag.div current_user_new_encount_dogs_count, class: "w-4 h-4 rounded-full text-center bg-red-500 text-white text-xs ml-3"
    end
      
  end

  def new_encount_dog_badge(encount_dog)
    if encount_dog.acknowledge == false
      return tag.div class: "w-2 h-2 rounded-full text-center bg-red-500 text-xs mx-2"
    else
      return
    end
  end
end
