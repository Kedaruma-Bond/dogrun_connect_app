module DogHelper
  def encount_dogs_at_this_entry(entry, dogrun_place_id)
    encount_dogs_created_at_this_entry = Encount.where(created_at: entry.entry_at .. entry.exit_at)
                                                .where(dogrun_place_id: dogrun_place_id)
                                                .where(user_id: @dog.user_id)
                                                .joins(:dog).where(dogs: { public: 'public_view' })
    @encount_dogs_at_this_entry = encount_dogs_created_at_this_entry.map do |encount|
      Dog.find(encount.dog_id)
    end
    return @encount_dogs_at_this_entry
  end

  def css_class_dog_color_marker(dog)
    encount_dog = EncountDog.where(user_id: current_user.id).find_by(dog_id: dog.id)
    return 'rounded-full' if encount_dog.blank?

    case encount_dog.color_marker
    when 'red'
      'border-2 border-red-500 rounded-full'
    when 'green'
      'border-2 border-green-400 rounded-full'
    when 'blue'
      'border-2 border-blue-500 rounded-full'
    when 'yellow'
      'border-2 border-yellow-500 rounded-full'
    else
      'rounded-full'
    end
  end

  def css_class_encount_dog_color_marker(encount_dog)
    case encount_dog.color_marker
    when 'red'
      'border-2 border-red-500 rounded-full'
    when 'green'
      'border-2 border-green-400 rounded-full'
    when 'blue'
      'border-2 border-blue-500 rounded-full'
    when 'yellow'
      'border-2 border-yellow-500 rounded-full'
    else
      'rounded-full'
    end
  end
end
