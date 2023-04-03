class Admin::StaffsController < Admin::BaseController
  include Pagy::Backend
  before_action :staff_params, only: %i[create]
  before_action :set_staff, only: %i[destroy enable_notification disable_notification]
  before_action :correct_admin_check, only: %i[destroy enable_notification disable_notification]

  def index
    @staff = Staff.new
    @pagy, @staffs = pagy(Staff.where(dogrun_place_id: current_user.dogrun_place_id).order(id: :desc))
  end

  def create
    @staff = Staff.new(staff_params)
    @dogrun_place = DogrunPlace.find(current_user.dogrun_place_id)

    if @staff.save
      StaffMailer.staff_registration_success(@staff, @dogrun_place).deliver_now
      respond_to do |format|
        format.html { redirect_to admin_staffs_path, success: t('.staff_create') }
        format.json { head :no_content }
      end
    else
      redirect_to  admin_staffs_path, error: t(".fail_to_register")
    end
  end

  def destroy
    @staff.destroy
    respond_to do |format|
      format.html { 
        if request.referer.nil?
          redirect_to admin_staffs_path, success: t('defaults.destroy_successfully'), status: :see_other 
        else
          redirect_to request.referer, success: t('defaults.destroy_successfully'), status: :see_other
        end
      }
      format.json { head :no_content }
    end
  end

  def enable_notification
    @staff.update!(enable_notification: true)
    respond_to do |format|
      format.html { 
        if request.referer.nil?
          redirect_to admin_staffs_path, success: t('.change_to_enable')
        else
          redirect_to request.referer, success: t('.change_to_enable')
        end
        }
      format.json { head :no_content }
    end
  end

  def disable_notification
    @staff.update!(enable_notification: false)
    respond_to do |format|
      format.html { 
        if request.referer.nil?
          redirect_to admin_staffs_path, success: t('.change_to_disable')
        else
          redirect_to request.referer, success: t('.change_to_disable')
        end
      }
      format.html { head :no_content }
    end
  end

  private

    def set_staff
      @staff = Staff.find(params[:id])
    end

    def staff_params
      params.require(:staff).permit(
        :name, :email, :enable_notification
      ).merge(dogrun_place_id: current_user.dogrun_place_id)
    end

    def correct_admin_check
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin? ||  @staff.dogrun_place == current_user.dogrun_place
    end
end
