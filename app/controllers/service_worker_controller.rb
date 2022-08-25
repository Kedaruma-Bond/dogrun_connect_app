class ServiceWorkerController < ApplicationController
  protect_from_forgery except: :service_worker
  skip_before_action :require_login

  def service_worker; end

  def offline; end
end
