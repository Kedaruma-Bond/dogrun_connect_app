module EntriesHelper
  def set_entries_array
    @entries = []
    @active_entries = []
  end

  def entry_to_dogrun(entries)
    n = entries.size - 1
    session[:entries] = []
    entries[0..n].each do |e|
      session[:entries] << e.id
    end
  end

  def during_entries
    @during_entries = []
    @during_entries = session[:entries]
  end

  def not_entry?
    during_entries.nil?
  end

  def exit_from_dogrun
    session.delete(:entries)
    @during_entries = nil
  end

  def select_dogs_allocation(select_dogs)
    @select_dogs_values = select_dogs.values
  end

  def clear_zero
    @num = 0
    @zero_count = 0
  end
end
