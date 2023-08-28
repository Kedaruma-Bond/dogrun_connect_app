require 'active_support'

module EntryConcern
  extend ActiveSupport::Concern

  def exit_from_dogrun
    
    current_entries.each do |entry|
      Entry.find(entry.id).update!(exit_at: Time.zone.now)
    end
    
  end

  def select_dogs_allocation(select_dogs)
    @select_dogs_values = []
    return unless select_dogs.present?
    # .valuesでハッシュの全値を配列にして返してくれる
    @select_dogs_values = select_dogs.values
  end
  
  def clear_zero
    @entries_array = []
    @non_public_dog_pre_entries = []
    @non_public_dog_entries = []
    @num = 0
    @zero_count = 0
  end

  def set_num_of_playing_dogs
    dogrun_entry_data = []
    dogrun_entry_data = Entry.where.not(entry_at: nil).where(exit_at: nil).joins(:registration_number).where(registration_numbers: { dogrun_place: @dogrun_place })
    @num_of_playing_dogs = dogrun_entry_data.size || 0
    if !dogrun_entry_data.blank?
      dogs = dogrun_entry_data.map do |entry_data|
        Dog.find(entry_data.dog_id)
      end
  
      @entry_dogs_public_view_include_own_dog = dogs.select do |dog|
        dog.public == 'public_view' || dog.user == current_user
      end
  
      @entry_dogs_non_public = dogs.select do |dog|
        dog.public == 'non_public'
      end
    else
      @entry_dogs_public_view_include_own_dog = []
      @entry_dogs_non_public = [] 
    end
  end

end
