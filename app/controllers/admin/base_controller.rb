class Admin::BaseController < ApplicationController
  before_action :check_admin
  layout 'admin/layouts/application'

  private

    def set_dogrun_place
      @dogrun_place = DogrunPlace.find(current_user.dogrun_place_id)
    end

    def set_naming_of_registration_number
      case current_user.dogrun_place.id
      when 2
        @naming_of_registration_number = t('togo_inu_shitsuke_hiroba.registration_number')
        @naming_of_registration_card = t('togo_inu_shitsuke_hiroba.registration_card')
      when 3
        @naming_of_registration_number = t('reon.registration_number')
        @naming_of_registration_card = t('reon.registration_card')
      else
        @naming_of_registration_number = t('defaults.registration_number')
        @naming_of_registration_card = t('defaults.registration_card')
      end
    end

    def not_authenticated
      redirect_to admin_login_path, error: t('defaults.require_login')
    end
    
    def check_admin
      redirect_to root_path, error: t('defaults.not_authorized') unless current_user.admin? || current_user.grand_admin?
    end

    def check_grand_admin
      redirect_to admin_root_path, error: t('defaults.not_authorized') unless current_user.grand_admin?
    end
  
end
