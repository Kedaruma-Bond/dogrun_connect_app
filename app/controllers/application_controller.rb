class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :notice, :error
  # セッションのCSRF対策について 後日調査します
  protect_from_forgery with: :null_session

  def not_authenticated
    redirect_to '/', error: t('defaults.require_login')
  end

  # def set_csrf_token_header
  #   response.set_header('X-CSRF-Token', form_authenticity_token)
  # end
end
