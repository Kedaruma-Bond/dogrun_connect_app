class TogoInuShitsukeHiroba::FriendDogGeneratorJob < ApplicationJob
  queue_as :default

  def perform
    if Rails.cache.exist?('previous_dogs_id')
    p Rails.cache.read('previous_dogs_id')
      previous_dogs_id = Rails.cache.read('previous_dogs_id')
      Rails.cache.delete('previous_dogs_id')
    end

    during_entry_dogs = Dog.dogrun_place_id_for_friend_dog(2)
    during_entry_dogs_id = during_entry_dogs.map do |dog|
      dog.id
    end

    Rails.cache.write('previous_dogs_id', during_entry_dogs_id)
    return if previous_dogs_id.nil?

    friend_dogs_ary = [previous_dogs_id, during_entry_dogs_id].inject(&:&)

    p Rails.cache.read('previous_dogs_id')
    p friend_dogs_ary

    friend_dogs_ary.each do |id|
      t = 0
      subject_dog_id = id
      friend_dogs_ary.count.times do
        friend_dog_id = friend_dogs_ary[t]
        if subject_dog_id != friend_dog_id
          FriendDog.create!(dogrun_place_id: 2, subject_dog_id: subject_dog_id, friend_dog_id: friend_dog_id)
        end
        t += 1
      end
    end

  end
end
