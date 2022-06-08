class ApplicationController < ActionController::Base
  # セッションのCSRF対策について 後日調査します
  protect_from_forgery with: :exception

  def not_authenticated
    redirect_to '/', error: t('.require_login')
  end

  # def set_csrf_token_header
  #   response.set_header('X-CSRF-Token', form_authenticity_token)
  # end
end
