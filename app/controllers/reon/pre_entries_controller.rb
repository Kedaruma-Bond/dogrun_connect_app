class Reon::PreEntriesController < Reon::DogrunPlaceController
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[destroy]

  def destroy
    current_pre_entries
    @current_pre_entries.each do |pre_entry|
      pre_entry.destroy
      pre_entry.destroy_broadcast
    end
    respond_to do |format|
      format.html { redirect_to send(@top_path), success: t('local.pre_entries.pre_entries_canceled_successfully'), status: :see_other }
      format.turbo_stream { flash.now[:success] = t('local.pre_entries.pre_entries_canceled_successfully') }
    end
  end

end
