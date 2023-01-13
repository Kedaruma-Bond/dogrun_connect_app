require 'active_support'

module EntryConcern
  extend ActiveSupport::Concern

  def exit_from_dogrun
    num = 0
    
    current_entries.each do |entry|
      Entry.find(entry.id).update!(exit_at: Time.zone.now)
    end
    
    @current_entries = nil
  end

  def select_dogs_allocation(select_dogs)
    @select_dogs_values = []
    return unless select_dogs.present?
    # .valuesでハッシュの全値を配列にして返してくれる
    @select_dogs_values = select_dogs.values
  end
  
  def clear_zero
    @num = 0
    @zero_count = 0
  end

end
