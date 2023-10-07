class Reon::EntriesController < Reon::DogrunPlaceController
  include Pagy::Backend
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[create update]
  before_action :set_q, only: %i[index search]
  before_action :correct_user_check, only: %i[destroy]

  def index
    @pagy, @entries = pagy(@entries, link_extra: 'data-turbo-stream="true" data-controller="autoclick"')
  end

  def create
    if @dogrun_place.closed_flag == true # ドッグランがclose時の処理
      redirect_to send(@top_path), error: t('local.entries.dogrun_is_closing_now')
      return
    end
    
    clear_zero # 初期化
    
    if not_pre_entry? # プレエントリーしていない場合
      if params[:select_dog].blank? # プレエントリー失効時の処理
        respond_to do |format|
          format.html { redirect_to send(@top_path), error: t('local.entries.pre_entry_has_been_expired') }
          format.turbo_stream { flash.now[:error] = t('local.entries.pre_entry_has_been_expired') }
        end
        return
      end

      select_dogs_allocation(params[:select_dog]) # select_dogを配列化して取得
      
      case params[:pre_flg]
      when "0" # 入場処理
        while @num <= @select_dogs_values.count - 1
          @dog = @dogs[@num]
          
          if Entry.where(dog: @dog).where(exit_at: nil).present? # すでに入場済の場合の処理
            set_num_of_playing_dogs
            respond_to do |format|
              format.html { redirect_to send(@top_path), error: t('local.entries.select_dog_has_already_entered') }
              format.turbo_stream { flash.now[:error] = t('local.entries.select_dog_has_already_entered') }
            end
            return
          end
          
          @registration_number = @registration_numbers[@num]
          
          case @select_dogs_values[@num]
          when '1' # 該当ワンコが選択されていたら入場させる処理
            @entries_array[@num] = Entry.new(entry_params)
            @entries_array[@num].entry_at = Time.zone.now
            @entries_array[@num].save!
            @entries_array[@num].create_broadcast

            @entry = @entries_array[@num]
            if @entry.dog.public_view?
              @entry.entry_broadcast_for_top(@entry.dog, current_user, @dogrun_place, @dog_profile_path)
              @entry.entry_broadcast_for_index(@dog_profile_path, @entry_path)
            elsif @entry.dog.non_public?
              @non_public_dog_entries << @entry
            end
          else # 該当ワンコが非選択時の処理
            @zero_count += 1
            @entries_array[@num] = nil
          end
          @num += 1
        end

        if @dogs.count == @zero_count # ワンコがわんこが一頭も選択されていない場合の処理
          respond_to do |format|
            format.html { 
              set_num_of_playing_dogs
              redirect_to send(@top_path), error: t('local.entries.select_entry_dog') 
            }
            format.turbo_stream { flash.now[:error] = t('local.entries.select_entry_dog') }
          end
        else # 一頭でもワンコが選択されていた場合の処理
          @entry_for_time = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place: @dogrun_place }).find_by(exit_at: nil) unless not_entry?(current_user, @dogrun_place)
          
          set_num_of_playing_dogs
          @entry.update_num_of_playing_dogs_broadcast(@num_of_playing_dogs, @entry_dogs_non_public)

          respond_to do |format|
            format.html { redirect_to send(@top_path), success: t('local.entries.entry_success') }
            format.turbo_stream { flash.now[:success] = t('local.entries.entry_success') }
          end
        end
      when "1" # プレエントリー処理
        while @num <= @select_dogs_values.count - 1
          @dog = @dogs[@num]

          if PreEntry.where(dog: @dog).present? # すでにプレエントリー済の場合の処理
            respond_to do |format|
              format.html { redirect_to send(@top_path), error: t('local.entries.select_dog_has_already_pre_entered') }
              format.turbo_stream { flash.now[:error] = t('local.entries.select_dog_has_already_pre_entered') }
            end
            return
          end

          @registration_number = @registration_numbers[@num]
          case @select_dogs_values[@num]
          when '1' # 該当ワンコが選択されていたらプレエントリーさせる処理
            @entries_array[@num] = PreEntry.new(pre_entry_params)
            @entries_array[@num].save!

            if @entries_array[@num].dog.public_view?
              @entries_array[@num].pre_entry_create_broadcast(@entries_array[@num].dog, current_user, @dogrun_place, @dog_profile_path)
            elsif @entries_array[@num].dog.non_public?
              @non_public_dog_pre_entries << @entries_array[@num]
            end
          else # 該当ワンコが非選択時の処理
            @zero_count += 1
            @entries_array[@num] = nil
          end
          @num += 1
        end

        if @dogs.count == @zero_count # ワンコが選択されていない場合の処理
          respond_to do |format|
            format.html { 
              set_num_of_playing_dogs
              redirect_to send(@top_path), error: t('local.entries.select_pre_entry_dog') 
            }
            format.turbo_stream { flash.now[:error] = t('local.entries.select_pre_entry_dog') }
          end
        else # 一頭でもワンコが選択されていた場合の処理
          respond_to do |format|
            format.html { redirect_to send(@top_path), success: t('local.entries.pre_entry_success') }
            format.turbo_stream { flash.now[:success] = t('local.entries.pre_entry_success') }
          end
        end
      end
    else # プレエントリーしてる場合
      current_pre_entries
      @current_pre_entries.each do |pre_entry|
        @entry = Entry.create(dog: pre_entry.dog, 
          registration_number: pre_entry.registration_number,
          entry_at: Time.zone.now)
        @entry.create_broadcast
        if @entry.dog.public_view?
          @entry.entry_broadcast_for_top(@entry.dog, current_user, @dogrun_place, @dog_profile_path)
          @entry.entry_broadcast_for_index(@dog_profile_path, @entry_path)
        elsif @entry.dog.non_public?
          @non_public_dog_entries << @entry
        end
        pre_entry.destroy
        pre_entry.destroy_broadcast
      end
      @entry_for_time = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place: @dogrun_place }).find_by(exit_at: nil) unless not_entry?(current_user, @dogrun_place)
      
      set_num_of_playing_dogs
      @entry.update_num_of_playing_dogs_broadcast(@num_of_playing_dogs, @entry_dogs_non_public)

      respond_to do |format|
        format.html { redirect_to send(@top_path), success: t('local.entries.entry_success') }
        format.turbo_stream { flash.now[:success] = t('local.entries.entry_success') }
      end
    end
  end

  def update
    if current_entries.blank?
      redirect_to send(@top_path), success: t('local.entries.exit_success')
      return
    end

    i = current_entries.size - 1
    @entry = current_entries[i]
    current_entries.each do |entry|
      Entry.find(entry.id).update(exit_at: Time.zone.now)
      Entry.find(entry.id).update_broadcast
    end
    
    set_num_of_playing_dogs
    @entry.update_num_of_playing_dogs_broadcast(@num_of_playing_dogs, @entry_dogs_non_public)

    respond_to do |format|
      format.html { redirect_to send(@top_path), success: t('local.entries.exit_success') }
      format.turbo_stream { flash.now[:success] = t('local.entries.exit_success') }
    end
  end

  def search
    @pagy, @entries_results = pagy(@q.result(distinct: true), link_extra: 'data-turbo-stream="true" data-controller="autoclick"')
  end

  def destroy
    @entry.destroy
    
    @entry.destroy_broadcast
    set_num_of_playing_dogs
    @entry.update_num_of_playing_dogs_broadcast(@num_of_playing_dogs, @entry_dogs_non_public)

    respond_to do |format|
      format.html { redirect_to send(@entries_path), success: t('defaults.destroy_successfully'), status: :see_other }
      format.turbo_stream { flash.now[:success] = t('defaults.destroy_successfully') }
    end
  end

  private

    def set_q
      @entries = Entry.includes(:registration_number, :dog)
                .where(registration_number: { dogrun_place: @dogrun_place })
                .where('dogs.public = ? OR dogs.user_id = ?', 'true', current_user.id)
                .order(entry_at: :desc)
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

    def correct_user_check
      @entry = Entry.find(params[:id])
      redirect_to send(@entries_path), error: t('defaults.not_authorized') unless @entry.dog.user == current_user
    end
    
end
