class TogoInuShitsukeHiroba::EntriesController < TogoInuShitsukeHiroba::DogrunPlaceController
  include Pagy::Backend
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[create]
  before_action :set_entries_array, only: %i[create update]
  before_action :set_q, only: %i[index search]

  def index
    @pagy, @entries = pagy(@entries)
  end

  def create
    clear_zero
    select_dogs_allocation(params[:select_dog])
    while @num <= @select_dogs_values.count - 1
      @dog = @dogs[@num]
      @registration_number = @registration_numbers[@num]
      
      case @select_dogs_values[@num]
      when '1'
        @entries_array[@num] = Entry.new(entry_params)
        @entries_array[@num].entry_at = Time.zone.now
        @entries_array[@num].save!
      else
        @zero_count += 1
        @entries_array[@num] = nil
      end
      @num += 1
    end

    if @dogs.count == @zero_count
      redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_entry_dog')
      return
    end
    entry_to_dogrun(@entries_array)
    remember(@entries_array)
    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.entry_success')
  end

  def update
    exit_from_dogrun
    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.exit_success')
  end

  def search
    @pagy, @entries_results = pagy(@q.result)
  end

  private

    def set_q
      @entries = Entry.dogrun_place_id(2)
      @q = @entries.ransack(params[:q])
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
