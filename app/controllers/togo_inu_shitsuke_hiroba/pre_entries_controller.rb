class TogoInuShitsukeHiroba::PreEntriesController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[destroy]

  def destroy
    current_pre_entries
    @current_pre_entries.each do |pre_entry|
      pre_entry.destroy
    end
    respond_to do |format|
      format.html { redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.pre_entries_canceled_successfully'), status: :see_other }
      format.turbo_stream { flash.now[:success] = t('.pre_entries_canceled_successfully') }
    end
  end

end
