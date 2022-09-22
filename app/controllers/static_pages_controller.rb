class StaticPagesController < ApplicationController
  skip_before_action :require_login

  def top
    return unless logged_in?

    last_registration_number = RegistrationNumber.joins(:dog).find_by(dogs: { user_id: current_user.id })
    return unless last_registration_number.present?

    @dogrun_place = DogrunPlace.find(last_registration_number.dogrun_place_id)
    case @dogrun_place.id
    when 2
      @link = togo_inu_shitsuke_hiroba_top_path
      @name = @dogrun_place.name
      @image_url = "https://res.cloudinary.com/hryerpkcw/image/upload/ar_1:1,c_fill,f_auto,q_auto,r_max/v1661503968/togo_inu_shitsuke_hiroba_logo_dmshl1.png"
    when 3
      @link = "#"
      @name = @dogrun_place.name
      @image_url = "https://res.cloudinary.com/hryerpkcw/image/upload/f_auto,q_auto/v1663754184/odaka_ryokuchi_dogrun_logo_rdre9u.png"
    end

  end

  def provacy_policy; end

  def terms_of_service; end
end
