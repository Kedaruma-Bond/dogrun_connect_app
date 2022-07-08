class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :notice, :error
  # sessionのCSRF対策は後日調査
  protect_from_forgery with: :null_session

  def not_authenticated
    redirect_to '/', error: t('defaults.require_login')
  end

  # def set_csrf_token_header
  # .  response.set_header('X-CSRF-Token', form_authenticity_token)
  # end
end
