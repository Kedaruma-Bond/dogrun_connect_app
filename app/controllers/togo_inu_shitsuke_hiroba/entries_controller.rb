class TogoInuShitsukeHiroba::EntriesController < TogoInuShitsukeHiroba::DogrunPlaceController
  include Pagy::Backend
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[create]
  before_action :set_q, only: %i[index search]

  def index
    @pagy, @entries = pagy(@entriesx)
  end

  def create
    if not_pre_entry?
      @entries_array = []
      clear_zero
      select_dogs_allocation(params[:select_dog])
      
      case params[:pre_flg]
      when "0"
        while @num <= @select_dogs_values.count - 1
          @dog = @dogs[@num]
          
          if Entry.where(dog: @dog).where(exit_at: nil).present?
            redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_dog_has_already_entered')
            return
          end
          
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
        else
          redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.entry_success')
          return
        end
      when "1"
        while @num <= @select_dogs_values.count - 1
          @dog = @dogs[@num]

          if PreEntry.where(dog: @dog).present?
            redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_dog_has_already_pre_entered')
            return
          end

          @registration_number = @registration_numbers[@num]
          
          case @select_dogs_values[@num]
          when '1'
            @entries_array[@num] = PreEntry.new(pre_entry_params)
            @entries_array[@num].save!
          else
            @zero_count += 1
            @entries_array[@num] = nil
          end
          @num += 1
        end
        if @dogs.count == @zero_count
          redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_pre_entry_dog')
          return
        else
          redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.pre_entry_success')
          return
        end
      end
    else
      current_pre_entries
      @current_pre_entries.each do |pre_entry|
        Entry.create(dog: pre_entry.dog, 
          registration_number: pre_entry.registration_number,
          entry_at: Time.zone.now)
        pre_entry.destroy
      end
      redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.entry_success')
      return
    end

  end

  def update
    @entries_array = []
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

    def pre_entry_params
      params.permit(
        :dog_id, :registration_number_id,
        :minutes_passed_count
      ).merge(
        dog_id: @dog.id,
        registration_number_id: @registration_number.id
      )
    end
end
