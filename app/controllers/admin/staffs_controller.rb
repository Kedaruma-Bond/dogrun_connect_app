class Admin::StaffsController < Admin::BaseController
  before_action :set_staffs_in_admin, only: %i[index]
  before_action :staff_params, only: %i[create]
  before_action :set_staff, only: %i[destroy enable_notification disable_notification]

  def index
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params)
    @dogrun_place = DogrunPlace.find(current_user.dogrun_place_id)

    if @staff.save!
      StaffMailer.staff_registration_success(@staff, @dogrun_place).deliver_now
      respond_to do |format|
        format.html { redirect_to admin_staffs_path, success: t('.staff_create') }
        format.json { head :no_content }
      end
    end
  end

  def destroy
    @staff.destroy
    respond_to do |format|
      format.html { redirect_to admin_staffs_path, success: t('defaults.destroy_successfully'), status: :see_other }
      format.json { head :no_content }
    end
  end

  def enable_notification
    @staff.update!(enable_notification: true)
    respond_to do |format|
      format.html { redirect_to admin_staffs_path, success: t('.change_to_enable')}
      format.json { head :no_content }
    end
  end

  def disable_notification
    @staff.update!(enable_notification: false)
    respond_to do |format|
      format.html { redirect_to admin_staffs_path, success: t('.change_to_disable')}
      format.html { head :no_content }
    end
  end

  private

    def set_staffs_in_admin
      @staffs = Staff.where(dogrun_place_id: current_user.dogrun_place_id).order(id: :desc).page(params[:page])
    end
  
    def set_staff
      @staff = Staff.find(params[:id])
    end

    def staff_params
      params.require(:staff).permit(
        :name, :email, :enable_notification
      ).merge(dogrun_place_id: current_user.dogrun_place_id)
    end
end
