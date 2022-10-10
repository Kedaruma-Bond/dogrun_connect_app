module DogHelper
  def playing_together_dogs(entry, dogrun_place_id)
    friend_dogs_created_at_this_entry = FriendDog.where(created_at: entry.entry_at .. entry.exit_at)
                                                .where(dogrun_place_id: dogrun_place_id)
                                                .where(user_id: @dog.user_id)
                                                .joins(:dog).where.not(dogs: { public: 'non_public' })
    playing_together_dogs = friend_dogs_created_at_this_entry.map do |friend_dog|
      Dog.find(friend_dog.dog_id)
    end

    @playing_together_dogs = playing_together_dogs.uniq

    return @playing_together_dogs
  end
end
