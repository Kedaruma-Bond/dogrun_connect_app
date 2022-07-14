class TogoInuShitsukeHiroba::EntriesController < TogoInuShitsukeHiroba::MainController
  layout 'togo_inu_shitsuke_hiroba'
  before_action :set_dogs, :set_registration_numbers, :set_entries_array, only: %i[create update]
  before_action :set_active_entries, only: %i[update]

  def create
    @t.times do |x|
      @dog = @dogs[x - 1]
      @registration_number = @registration_numbers[x - 1]
      @entries[x] = Entry.new(entry_params)
      if @entries[x].select_dog == false
        @entries[x].clear
      else
        @entries[x].entry_at = Time.zone.now
        @entries[x].save!
        @entry_flag = true
      end
    end
    # Entry.insert_all! @entries
    return unless @entry_flag == true

    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.entry_success')
  end

  def update
    d = @entries.count
    d.times do |x|
      @entries[x].exit_at = Time.zone.now
    end
    Entry.update_all @entries # rubocop:disable Rails/SkipsModelValidations
    @entry_flag = false
    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.exit_success')
  end

  private

  def set_entries_array
    @entries = []
    @t = @dogs.count
  end

  def set_acitve_entries
    @t.times do |x|
      @entries << Entry.where(dog_id: @dogs[x - 1].id).merge(Entry.where.not(entry_at: nil))
    end
  end

  def entry_params
    params.permit(
      :dog_id, :registration_number_id,
      :entry_at, :exit_at,
      :select_dog
    ).merge(
      dog_id: @dog.id,
      registration_number_id: @registration_number.id
    )
  end
end
