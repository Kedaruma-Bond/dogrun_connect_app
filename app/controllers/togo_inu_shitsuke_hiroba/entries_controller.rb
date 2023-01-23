class TogoInuShitsukeHiroba::EntriesController < TogoInuShitsukeHiroba::DogrunPlaceController
  include Pagy::Backend
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[create update]
  before_action :set_q, only: %i[index search]

  def index
    @pagy, @entries = pagy(@entries)
  end

  def create
    if @dogrun_place.closed_flag == true
      respond_to do |format|
        format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.dogrun_is_closing_now') }
        format.turbo_stream { flash.now[:error] = t('.dogrun_is_closing_now') }
      end
      return
    end

    if not_pre_entry?
      @entries_array = []
      clear_zero
      select_dogs_allocation(params[:select_dog])
      
      case params[:pre_flg]
      when "0"
        while @num <= @select_dogs_values.count - 1
          @dog = @dogs[@num]
          
          if Entry.where(dog: @dog).where(exit_at: nil).present?
            respond_to do |format|
              format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_dog_has_already_entered') }
              format.turbo_stream { flash.now[:error] = t('.select_dog_has_already_entered') }
            end
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
          respond_to do |format|
            format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_entry_dog') }
            format.turbo_stream { flash.now[:error] = t('.select_entry_dog') }
          end
        else
          @entry_for_time = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place: @dogrun_place }).find_by(exit_at: nil) unless not_entry?
          set_num_of_playing_dogs
          respond_to do |format|
            format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.entry_success') }
            format.turbo_stream { flash.now[:success] = t('.entry_success') }
          end
        end
      when "1"
        while @num <= @select_dogs_values.count - 1
          @dog = @dogs[@num]

          if PreEntry.where(dog: @dog).present?
            respond_to do |format|
              format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_dog_has_already_pre_entered') }
              format.turbo_stream { flash.now[:error] = t('.select_dog_has_already_pre_entered') }
            end
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
          respond_to do |format|
            format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, error: t('.select_pre_entry_dog') }
            format.turbo_stream { flash.now[:error] = t('.select_pre_entry_dog') }
          end
        else
          respond_to do |format|
            format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.pre_entry_success') }
            format.turbo_stream { flash.now[:success] = t('.pre_entry_success') }
          end
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
      @entry_for_time = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place: @dogrun_place }).find_by(exit_at: nil) unless not_entry?
      set_num_of_playing_dogs
      respond_to do |format|
        format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.entry_success') }
        format.turbo_stream { flash.now[:success] = t('.entry_success') }
      end
    end

  end

  def update
    @entries_array = []
    exit_from_dogrun
    set_num_of_playing_dogs
    respond_to do |format|
      format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.exit_success') }
      format.turbo_stream { flash.now[:success] = t('.exit_success') }
    end
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

    def set_num_of_playing_dogs
      dogrun_entry_data = []
      dogrun_entry_data = Entry.where.not(entry_at: nil).where(exit_at: nil).joins(:registration_number).where(registration_numbers: { dogrun_place: @dogrun_place })
      @num_of_playing_dogs = dogrun_entry_data.size || 0
      if !dogrun_entry_data.blank?
        dogs = dogrun_entry_data.map do |entry_data|
          Dog.find(entry_data.dog_id)
        end
    
        @dogs_public_view = dogs.select do |dog|
          dog.public == 'public_view'
        end
    
        @dogs_non_public = dogs.select do |dog|
          dog.public == 'non_public'
        end
      else
        @dogs_public_view = []
        @dogs_non_public = [] 
      end
    end

end
