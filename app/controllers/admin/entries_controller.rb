class Admin::EntriesController < Admin::BaseController
  include Pagy::Backend
  before_action :set_naming_of_registration_number, only: %i[index search]
  before_action :set_q, only: %i[index search]
  before_action :set_entry, only: %i[update destroy]
  before_action :correct_admin_check, only: %i[update destroy]
  before_action :set_dogrun_place, only: %i[index create update destroy search]

  def index
    set_num_of_playing_dogs
    @pagy, @entries = pagy(@entries)
  end

  def create
    session[:previous_url] = request.referer
    if @dogrun_place.closed_flag == true
      respond_to do |format|
        format.html { 
          if session[:previous_url].nil?
            redirect_to admin_dogs_path, error: t('local.entries.dogrun_is_closing_now')
          else
            redirect_to session[:previous_url], error: t('local.entries.dogrun_is_closing_now')
          end
        }
        format.turbo_stream { flash.now[:error] = t('local.entries.dogrun_is_closing_now') }
      end
      return
    end

    @dog = Dog.find(params[:dog_id])
    @rn = dog_relative_registration_number(@dog, current_user)
    @entry = Entry.new(entry_params)
    @entry.entry_at = Time.zone.now
    @entry.save!
    @entry.create_broadcast
    respond_to do |format|
      format.html { 
        if session[:previous_url].nil?
          redirect_to admin_dogs_path, success: t('local.entries.entry_success')
        else
          redirect_to session[:previous_url], success: t('local.entries.entry_success')
        end
        }
      format.turbo_stream { flash.now[:success] = t('local.entries.entry_success') }
    end
  end

  def update
    # rspec通すためにこんなことしてるの馬鹿げてる
    session[:previous_url] = request.referer
    @entry.update(exit_at: Time.zone.now)

    @entry.update_broadcast
    set_num_of_playing_dogs
    @entry.update_num_of_playing_dogs_broadcast(@num_of_playing_dogs, @dogs_non_public)

    case params[:force_flg]
    when "1"
      UserMailer.force_exit_notification(@entry.dog.user,@entry.dog,@entry.registration_number.dogrun_place).deliver_now
      respond_to do |format|
        format.html { 
          if session[:previous_url].nil?
            redirect_to admin_entries_path, success: t('.force_exit_successfully') 
          else
            redirect_to session[:previous_url], success: t('.force_exit_successfully') 
          end
        }
        format.turbo_stream { flash.now[:success] = t('.force_exit_successfully')}
      end
    else
      respond_to do |format|
        format.html { 
          if session[:previous_url].nil?
            redirect_to admin_entries_path, success: t('.exit_successfully') 
          else
            redirect_to session[:previous_url], success: t('.exit_successfully') 
          end
        }
        format.turbo_stream { flash.now[:success] = t('.exit_successfully')}
      end
    end
  end

  def destroy
    # rspec通すためにこんなことしてるの馬鹿げてる
    session[:previous_url] = request.referer
    @entry.destroy

    @entry.destroy_broadcast
    set_num_of_playing_dogs
    @entry.update_num_of_playing_dogs_broadcast(@num_of_playing_dogs, @dogs_non_public)

    respond_to do |format|
      format.html { 
        if session[:previous_url].nil?
          redirect_to admin_entries_path, success: t('defaults.destroy_successfully'), status: :see_other
        else
          redirect_to session[:previous_url], success: t('defaults.destroy_successfully'), status: :see_other
        end
      }
      format.turbo_stream { flash.now[:success] = t('defaults.destroy_successfully') }
    end
  end

  def search
    set_num_of_playing_dogs
    @pagy, @entries_results = pagy(@q.result)
  end

  private

    def set_q
      @entries = Entry.admin_dogrun_place_id(current_user.dogrun_place_id)
      @q = @entries.ransack(params[:q])
    end

    def entry_params
      params.permit(
        :dog_id, :registration_number_id,
        :entry_at, :exit_at,
        :dog_id
      ).merge(
        dog_id: @dog.id,
        registration_number_id: @rn.id
      )
    end

    def set_entry
      @entry = Entry.find(params[:id])
    end

    def correct_admin_check
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin? ||  @entry.dogrun_place == current_user.dogrun_place
    end

end
