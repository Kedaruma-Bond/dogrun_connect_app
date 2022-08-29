class TogoInuShitsukeHiroba::EntriesController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_dogs, :set_registration_numbers_in_togo_inu_shitsuke_hiroba, only: %i[create]
  before_action :set_entries_array, only: %i[create update]

  def create
    exit_from_dogrun
    clear_zero
    select_dogs_allocation(params[:select_dog])
    while @num <= @dogs.count - 1
      @dog = @dogs[@num]
      @registration_number = @registration_numbers[@num]
      @entries[@num] = Entry.new(entry_params)
      case @select_dogs_values[@num]
      when '1'
        @entries[@num].entry_at = Time.zone.now
        @active_entries << @entries[@num]
        @entries[@num].save!
      else
        @zero_count += 1
      end
      @num += 1
    end
    if @dogs.count == @zero_count
      redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_entry_dog')
      return
    end
    entry_to_dogrun(@active_entries)
    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.entry_success')
  end

  def update
    num = 0
    during_entries[0..during_entries.size - 1].each do
      @entries[num] = Entry.find(during_entries[num])
      @entries[num].update!(exit_at: Time.zone.now)
      num += 1
    end
    exit_from_dogrun
    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.exit_success')
  end

  private

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
