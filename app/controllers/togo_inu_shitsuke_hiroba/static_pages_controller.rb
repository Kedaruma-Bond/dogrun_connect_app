class TogoInuShitsukeHiroba::StaticPagesController < TogoInuShitsukeHiroba::MainController
  layout 'togo_inu_shitsuke_hiroba'
  skip_before_action :require_login
  before_action :set_dogs, :set_registration_numbers, :get_entry_data, :clear_entry_flag, only: %i[top]

  def top
    @entry = Entry.new
    @number_of_dogs = @entry_data.size || 0
  end

  def compliance_confirmations; end

  private

  def get_entry_data
    @entry_data = []
    @entry_data = Entry.where.not(entry_at: nil).where(exit_at: nil).joins(:registration_number).where(registration_numbers: { dogrun_place: 'togo_inu_shituke_hiroba' })
  end
end
