namespace :friend_dog_generator do
  desc "ドッグランに入場中のワンちゃんたちからfriend_dogレコードを作成する"
  task togo_inu_shitsuke_hiroba: :environment do
    if Rails.cache.exist?('previous_dogs_id')
      previous_dogs_id = Rails.cache.read('previous_dogs_id')
      Rails.cache.delete('previous_dogs_id')
    end

    during_entry_dogs = Dog.dogrun_place_id_for_friend_dog(2)
    next if during_entry_dogs.blank?

    p '*' * 10
    p 'redis store data' 
    p previous_dogs_id
    p '*' * 10
    
    during_entry_dogs_id = during_entry_dogs.map do |dog|
      dog.id
    end

    p '*' * 10
    p 'present data' 
    p during_entry_dogs_id
    p '*' * 10

    Rails.cache.write('previous_dogs_id', during_entry_dogs_id)
    next if previous_dogs_id.blank?

    friend_dogs_id_ary = [previous_dogs_id, during_entry_dogs_id].inject(&:&)

    p '*' * 10
    p 'distinct data' 
    p friend_dogs_id_ary
    p '*' * 10

    friend_dogs_user_id_ary = friend_dogs_id_ary.map do |id|
      dog = Dog.find(id)
      dog.user_id
    end

    friend_dogs_user_id_ary.each do |user_id|
      t = 0
      friend_dogs_id_ary.each do |dog_id|
        dog = Dog.find(dog_id)
        if dog.user_id != user_id
          FriendDog.create!(dogrun_place_id: 2, user_id: user_id, dog_id: dog_id)
        end
        t += 1
      end
    end
  end
end
