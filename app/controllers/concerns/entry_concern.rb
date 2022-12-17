require 'active_support'

module EntryConcern
  extend ActiveSupport::Concern

  def remember(entries_array)
    entries_id = []
    entries_token = []
    entries_array.each do |entry|
      return if entry.nil?
      
      entry.remember
      entries_id << entry.id
      entries_token << entry.entry_token
    end
    cookies.permanent.encrypted[:entries_id] = JSON.generate(entries_id)
    cookies.permanent[:entries_token] = JSON.generate(entries_token)
  end
  
  def forget(entries)
    entries.each do |entry|
      entry.forget
    end
    cookies.delete(:entries_id)
    cookies.delete(:entries_token)
  end

  def exit_from_dogrun
    num = 0
    
    current_entries.each do |entry|
      Entry.find(entry.id).update!(exit_at: Time.zone.now)
    end
    
    forget(current_entries)
    session.delete(:entries_id)
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
