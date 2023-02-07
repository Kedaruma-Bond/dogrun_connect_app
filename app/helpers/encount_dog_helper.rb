module EncountDogHelper
  include Pagy::Frontend
  def new_encount_dog_count_badge
    current_user_new_encount_dogs_count = EncountDog.joins(:dog).where(dogs: { public: 'public_view' }).where(user_id: current_user.id).where(acknowledge: false).count
    unless current_user_new_encount_dogs_count == 0
      tag.span class: "flex w-5 h-5 ml-3" do
        concat tag.span(class: "animate-ping inline-flex h-full w-full rounded-full aspect-square bg-indigo-400 dark:bg-indigo-200 opacity-75")
        concat tag.span(current_user_new_encount_dogs_count, class: "text-sm font-medium relative inline-flex w-5 h-5 rounded-full bg-indigo-500 dark:bg-indigo-300 text-gray-200 dark:text-gray-700 justify-center aspect-square right-5")
      end
    end
  end

  def new_encount_dog_badge(encount_dog)
    if encount_dog.acknowledge == false
      tag.div class: "flex relative w-0 h-0" do
        concat tag.span(class: "w-3 h-3 absolute top-2 animate-ping rounded-full aspect-square bg-indigo-400 dark:bg-indigo-200 opacity-75")
        concat tag.span(class: "rounded-full aspect-square h-3 w-3 top-2 relative bg-indigo-500 dark:bg-indigo-300")
      end
    end
  end
end
