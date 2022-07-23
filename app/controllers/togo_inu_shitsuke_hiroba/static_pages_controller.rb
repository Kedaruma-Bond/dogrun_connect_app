class TogoInuShitsukeHiroba::StaticPagesController < TogoInuShitsukeHiroba::DogrunPlaceController
  layout 'togo_inu_shitsuke_hiroba'
  skip_before_action :require_login
  before_action :set_dogs, :set_registration_numbers_in_togo_inu_shitsuke_hiroba, :get_entry_data, :during_entries, :get_during_entry_user_dogs, only: %i[top]

  def top
    @entry = Entry.new
    @number_of_dogs = @entry_data.size || 0
  end

  def compliance_confirmations; end

  private

  def get_entry_data
    @entry_data = []
    @entry_data = Entry.where.not(entry_at: nil).where(exit_at: nil).joins(:registration_number).where(registration_numbers: { dogrun_place: 'togo_inu_shitsuke_hiroba' })
  end

  def get_during_entry_user_dogs
    return if not_entry?

    entries = []
    @during_entry_user_dogs = []
    num = @during_entries.size || 0
    x = 0
    num.times do
      entries += Entry.where('id = ?', @during_entries[x])
      @during_entry_user_dogs += Dog.where('id = ?', entries[x].dog_id)
      x += 1
    end
  end
end
