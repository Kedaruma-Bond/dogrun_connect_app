module EntryHelper
  
  def during_entries
    @during_entries = []
    @during_entries = session[:entries]
  end
  
  def not_entry?
    @during_entries.nil?
  end
end
