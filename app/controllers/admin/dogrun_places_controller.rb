class Admin::DogrunPlacesController < Admin::BaseController
  include Pagy::Backend
  before_action :check_grand_admin, except: %i[show edit update force_closed release]
  before_action :correct_admin_user, only: %i[show edit update force_closed release]
  before_action :set_naming_of_registration_number, only: %i[new show edit]
  
  def index
    @pagy, @dogrun_places = pagy(DogrunPlace.with_attached_logo.includes([:dogrun_place_facility_relations], [:facilities]).order(created_at: :desc))
    @facilities = Facility.all
  end

  def show
    @dogrun_place = DogrunPlace.find(params[:id])
  end

  def new
    @dogrun_place = DogrunPlace.new
  end

  def create
    @dogrun_place = DogrunPlace.new(dogrun_place_params)
    if @dogrun_place.save
      redirect_to admin_dogrun_places_path, success: t('.create_success')
      return
    end
    render :new, status: :unprocessable_entity
  end

  def edit
    @dogrun_place = DogrunPlace.find(params[:id])
  end

  def update
    @dogrun_place = DogrunPlace.find(params[:id])
    if @dogrun_place.update(dogrun_place_params)
      if current_user.grand_admin?
        redirect_to admin_dogrun_places_path, success: t('defaults.update_successfully')
      else
        redirect_to admin_dogrun_place_path(@dogrun_place), success: t('defaults.update_successfully')
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def force_closed
    @dogrun_place = DogrunPlace.find(params[:id]) 
    @dogrun_place.update(force_closed: true, closed_flag: true)
    @dogrun_place.update_broadcast
    current_entries = Entry.includes(:registration_number).where(registration_numbers: { dogrun_place: @dogrun_place }).where(exit_at: nil)
    current_entries.each do |entry|
      entry.update(exit_at: Time.zone.now)
    end
    respond_to do |format|
      format.html { redirect_to  admin_dogrun_place_path(@dogrun_place), success: t('.forced_dogrun_to_close') }
      format.turbo_stream { flash.now[:success] = t('.forced_dogrun_to_close') }
    end
  end

  def release
    @dogrun_place = DogrunPlace.find(params[:id]) 
    @dogrun_place.update(force_closed: false, closed_flag: false)
    @dogrun_place.update_broadcast
    respond_to do |format|
      format.html { redirect_to  admin_dogrun_place_path(@dogrun_place), success: t('.released_dogrun_to_open') }
      format.turbo_stream { flash.now[:success] = t('.released_dogrun_to_open') }
    end
  end

  private

    def dogrun_place_params
      params.require(:dogrun_place).permit(
        :name, :description, :usage_fee, :prefecture_code, :logo,
        :address, :opening_time, :closing_time, :web_site, :site_area,
        :registration_card, facility_ids: []
      )
    end
    
    def correct_admin_user
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin? || DogrunPlace.find(params[:id]) == current_user.dogrun_place
    end

end
