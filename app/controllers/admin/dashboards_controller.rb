class Admin::DashboardsController < Admin::BaseController
  def index
    to = Time.current.at_end_of_day
    from = (to - 1.month)
    @today = Date.today
    @two_weeks_ago = @today.prev_day(14)
    @one_year_ago = @today.prev_day(365)
    if current_user.name == 'grand_admin'
      @entries_over_the_past_month = Entry.where(entry_at: from..to)
      @users = User.all
      @registration_dogs = Dog.all
      @new_registration_dogs_over_the_past_month = Dog.where(created_at: from..to)
      @entries = Entry.all
    else 
      @entries_over_the_past_month = Entry.where(entry_at: from..to).joins(:registration_number).where(registration_number: { dogrun_place: current_user.dogrun_place })
      @registration_dogs = RegistrationNumber.where(dogrun_place: current_user.dogrun_place)
      @new_registration_dogs_over_the_past_month = RegistrationNumber.where(dogrun_place: current_user.dogrun_place).where(created_at: from..to)
      @entries = Entry.joins(:registration_number).where(registration_number: { dogrun_place: current_user.dogrun_place })
    end
  end
end
