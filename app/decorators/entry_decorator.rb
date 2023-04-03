module EntryDecorator
  def own_entry?
    if self.dog.user == current_user && self.created_at > 5.minutes.ago
      return true
    else
      return false
    end
  end
end
