class Admin::EntriesController < Admin::BaseController
  include Pagy::Backend
  before_action :set_q, only: %i[index search]
  before_action :set_entry, only: %i[destroy]

  def index
    @pagy, @entries = pagy(@entries)
  end

  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to admin_entries_path, success: t('defaults.destroy_successfully'), status: :see_other }
      format.json { head :no_content }
    end
  end

  def search
    @pagy, @entries_results = pagy(@q.result)
  end

  private

    def set_q
      @entries = Entry.admin_dogrun_place_id(current_user.dogrun_place_id)
      @q = @entries.ransack(params[:q])
    end

    def set_entry
      @entry = Entry.find(params[:id])
    end

end
