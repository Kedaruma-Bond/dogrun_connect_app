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
    when 3
      @link = "#"
    end

  end

  def provacy_policy; end

  def terms_of_service; end
  
  def notice_for_filming_approval; end

  def notice_for_sns_post_approval; end
end
