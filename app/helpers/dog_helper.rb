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

  def color_marker(dog)
    applied_dog = EncountDog.where(dog_id: dog.id)
    color = applied_dog.color_marker
    return @color
  end
end
