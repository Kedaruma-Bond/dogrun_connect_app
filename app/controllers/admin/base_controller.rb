class Admin::BaseController < ApplicationController
  before_action :check_admin
  layout 'admin/layouts/application'

  private

  def not_authenticated
    redirect_to admin_root_path, error: t('defaults.require_login')
  end
  
  def check_admin
    redirect_to root_path, error: t('defaults.not_authorized') unless current_user.admin?
  end

  def check_grand_admin
    redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.name == 'grand_admin' && current_user.admin?
  end

  def skip_bullet
    previous_value = Bullet.enable?
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = previous_value
  end
  
end
