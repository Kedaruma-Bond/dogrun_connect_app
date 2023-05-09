class ReonEncountGeneratorJob
  def call
    ActiveRecord::Base.transaction do
      if Rails.cache.exist?('reon_previous_dogs_id')
        previous_dogs_id = Rails.cache.read('reon_previous_dogs_id')
        Rails.cache.delete('reon_previous_dogs_id')
      end
  
      # p '*' * 10
      # p 'redis store data' 
      # p previous_dogs_id

      dogrun_place_id = 3
      
      during_entry_dogs_id = Entry.dogrun_place_id_for_encount_dog(dogrun_place_id).pluck(:dog_id)
      return if during_entry_dogs_id.blank?
      
      
      # p 'present data' 
      # p during_entry_dogs_id
      # p '*' * 10
      
      Rails.cache.write('reon_previous_dogs_id', during_entry_dogs_id)
      return if previous_dogs_id.blank?
      
      # 重複したidを抜き出し今回の記録ターゲットにする
      encount_dogs_id_ary = [previous_dogs_id, during_entry_dogs_id].inject(&:&)
      
      # p 'distinct data for create encount' 
      # p encount_dogs_id_ary
      # p '*' * 10
      
      encount_dogs_user_id_ary = encount_dogs_id_ary.map do |id|
        dog = Dog.find(id)
        dog.user_id
      end
      
      # p 'user data for create encount' 
      # p encount_dogs_user_id_ary
      # p '*' * 10
      
      encount_dogs_user_id_ary.each do |user_id|
        
        # p 'user_id' 
        # p user_id
        # p '*' * 10
        
        present_entry = Entry.joins(:dog).where(dogs: { user_id: user_id }).where(created_at: Time.zone.now.all_day).last
        next if present_entry.nil? 
        
        # p 'present_entry' 
        # p present_entry
        # p '*' * 10
      
        encount_dogs_id_ary.each do |dog_id|
          dog = Dog.find(dog_id)
      
          # p 'dog_id' 
          # p dog_id
          # p '*' * 10
      
          if dog.user_id != user_id
            encount_dog = EncountDog.where(user_id: user_id).where(dog_id: dog_id)

            # p 'encount_dog' 
            # p encount_dog
            # p '*' * 10
      
            EncountDog.create!(dogrun_place_id: dogrun_place_id, user_id: user_id, dog_id: dog_id) if encount_dog.blank?
            
            encount_in_present_entry = Encount.where(entry_id: present_entry.id).where(dog_id: dog_id)

            # p 'encount_in_present_entry' 
            # p encount_in_present_entry
            # p '*' * 10
      
            Encount.create!(dogrun_place_id: dogrun_place_id, user_id: user_id, dog_id: dog_id, entry_id: present_entry.id) if encount_in_present_entry.blank?
          end
        end
      end
    end
  end
end

