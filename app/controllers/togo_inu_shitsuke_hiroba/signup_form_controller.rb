class TogoInuShitsukeHiroba::SignupFormController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  # skip_before_action :require_login, only: %i[index new create activate update]
  before_action :registration_params, only: :confirm

  def new
    session.delete(:signup_form)
    @registration = SignupForm.new
    @registration.password_confirmation = @registration.password
  end

  def confirm
    @registration = SignupForm.new(registration_params)
    if @registration.valid?
      session[:signup_form] = registration_params
      @password_dot = '*' * @registration.password.length
    else
      render :new
    end
  end

  def create
    @registration = SignupForm.new(session[:signup_form].to_hash)
    if params[:back]
      render :new, status: :unprocessable_entity
      return
    end

    if @registration.save
      UserMailer.activation_needed_email(@registration)
      session.delete(:signup_form)
      redirect_to togo_inu_shitsuke_hiroba_top_path, notice: t('.send_mail')
      return
    end
    render :new, status: :unprocessable_entity, error: t('.somethingwrong')
  end

  private

  def registration_params
    params.require(:signup_form).permit(
      :name, :email, :deactivation, :enable_notification, :password, :password_confirmation,
      :dog_name, :castration, :public, :birthday,
      :dogrun_place, :registration_number
    )
  end
end
