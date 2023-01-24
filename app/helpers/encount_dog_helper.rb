module EncountDogHelper
  include Pagy::Frontend
  def new_encount_dog_count_badge
    current_user_new_encount_dogs = EncountDog.joins(:dog).where(dogs: { public: 'public_view' }).where(user_id: current_user.id).where(acknowledge: false)
    current_user_new_encount_dogs_count = current_user_new_encount_dogs.count
    if current_user_new_encount_dogs_count == 0
      return
    else
      tag.span class: "flex w-5 h-5 ml-3" do
        concat tag.span(class: "animate-ping inline-flex h-full w-full rounded-full aspect-square bg-indigo-400 opacity-75")
        concat tag.span(current_user_new_encount_dogs_count, class: "text-sm relative inline-flex w-5 h-5 rounded-full bg-indigo-500 text-gray-200 justify-center aspect-square right-5")
      end
    end
  end

  def new_encount_dog_badge(encount_dog)
    if encount_dog.acknowledge == false
      tag.span class: "flex relative w-3 h-3 mt-2" do
        concat tag.span(class: "absolute top-5 left-1 animate-ping h-full w-full rounded-full aspect-square bg-indigo-400 opacity-75")
        concat tag.span(class: "rounded-full aspect-square h-3 w-3 top-5 left-1 relative bg-indigo-500")
      end
    else
      return
    end
  end
end
