class Admin::EntriesController < Admin::BaseController
  include Pagy::Backend
  before_action :set_q, only: %i[index search]
  before_action :set_entry, only: %i[destroy]

  def index
    @pagy, @entries = pagy(@entries)
  end

  def destroy
    session[:previous_url] = request.referer
    if @entry.registration_number.dogrun_place == current_user.dogrun_place
      @entry.destroy
      respond_to do |format|
        format.html { 
          if session[:previous_url].nil?
            redirect_to admin_entries_path, success: t('defaults.destroy_successfully'), status: :see_other 
          else
            redirect_to session[:previous_url], success: t('defaults.destroy_successfully'), status: :see_other
          end
        }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_root_path, error: t('defaults.not_authorized'), status: :see_other }
        format.json { head :no_content }
      end
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
