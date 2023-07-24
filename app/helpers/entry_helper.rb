module EntryHelper
  include Pagy::Frontend
  
  def current_entries
    return unless logged_in?

    @current_entries = nil
    entries = []

    entries = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place_id: @dogrun_place.id }).where(exit_at: nil).order(dog_id: :asc)
  
    return if entries.blank?

    if entries.class == Array
      @current_entries = Entry.where(id: entries.map(&:id))
    else
      @current_entries = entries
    end
    
  end

  def not_entry?(user, dogrun_place)
    Entry.user_id_at_local(user.id).where(registration_numbers: { dogrun_place_id: dogrun_place.id }).where(exit_at: nil).blank?
  end

  def current_pre_entries
    return unless logged_in?

    pre_entries = []

    pre_entries = PreEntry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place_id: @dogrun_place.id }).order(dog_id: :asc)
  
    return if pre_entries.blank?

    if pre_entries.class == Array
      @current_pre_entries = Entry.where(id: pre_entries.map(&:id))
    else
      @current_pre_entries = pre_entries
    end
  end

  def not_pre_entry?
    if logged_in?
      PreEntry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place_id: @dogrun_place.id }).blank? 
    else
      return true
    end
  end

  def admin_active_entry_serach(registration_number)
    entry = Entry.admin_dogrun_place_id(current_user.dogrun_place_id).where(registration_number: registration_number).find_by(exit_at: nil)
    if entry
      return entry
    else
      return false
    end
  end

end
