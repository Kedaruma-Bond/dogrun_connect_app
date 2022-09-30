module EntryHelper

  def entry_to_dogrun(entries_array)
    session[:entries_id] = entries_array.map do |e|
      return if e.nil?

      e.id
    end
  end

  def current_entries
    return unless logged_in?

    @current_entries = nil
    entries = []
    
    t = 0
    if (entries_id = session[:entries_id])
      entries_id.count.times do
        entries << Entry.find(entries_id[t])
        t += 1
      end
    elsif (!cookies[:entries_id].nil? && entries_id = JSON.parse(cookies.encrypted[:entries_id]))
      entries_id.size.times do
        entries_token = JSON.parse(cookies[:entries_token])
        entry = Entry.find(entries_id[t])
        if entry && entry.authenticated?(entries_token)
          entries << entry
        end
      end
      entry_to_dogrun(entries)
    elsif (entries = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place_id: 2 }).where(exit_at: nil))
      entry_to_dogrun(entries)
    else
      return
    end

      
    if entries.class == Array
      @current_entries = Entry.where(id: entries.map(&:id))
    else
      @current_entries = entries
    end
    
  end 

  def not_entry?
    if logged_in?
      Entry.joins(:dog).where(dogs: {user_id: current_user.id }).where(exit_at: nil).blank?
    else
      return true
    end
  end

end
