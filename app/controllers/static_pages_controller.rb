class StaticPagesController < ApplicationController
  skip_before_action :require_login, :is_account_deactivated?

  def top
    return unless logged_in?

    last_entry = Entry.joins(:dog).where(dogs: { user_id: current_user.id }).last
    return unless last_entry.present?

    @dogrun_place = DogrunPlace.find(last_entry.registration_number.dogrun_place_id)
    case @dogrun_place.id
    when 2
      @link = togo_inu_shitsuke_hiroba_top_path
    when 3
      @link = reon_top_path
    end

  end

  def provacy_policy; end

  def terms_of_service; end
  
end
