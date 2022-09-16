require 'active_support'

module EntryConcern
  extend ActiveSupport::Concern

  def set_entries_array
    @entries = []
    @active_entries = []
  end

  def entry_to_dogrun(entries)
    session[:entries] = entries.map do |e|
      e.id
    end
  end

  def exit_from_dogrun
    session.delete(:entries)
    @during_entries = nil
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
