class Admin::DashboardsController < Admin::BaseController
  include DashboardConcern
  before_action :check_grand_admin, only: %i[grand_admin_index]
  before_action :set_var

  def index
    @entries_over_the_past_month = Entry.where(entry_at: @from..@to).joins(:registration_number).where(registration_number: { dogrun_place_id: current_user.dogrun_place_id })
    @new_registration_dogs_over_the_past_month = RegistrationNumber.where(dogrun_place_id: current_user.dogrun_place_id).where(created_at: @from..@to)

    set_registration_dogs
    set_entries_of_past_one_year
    sex_type_ratio_graph
    daily_entries_graph
    monthly_entries_graph

  end

  def grand_admin_index
    @entries_over_the_past_month = Entry.where(entry_at: @from..@to)
    @users = User.all
    @users_over_the_past_month = User.where(created_at: @from..@to)
    @new_registration_dogs_over_the_past_month = Dog.where(created_at: @from..@to)

    set_registration_dogs
    set_entries_of_past_one_year
    sex_type_ratio_graph
    daily_entries_graph
    monthly_entries_graph
  end

  def entries_count
    @q = Entry.ransack(params[:q])
    return @entries = nil if params[:q].blank?

    if current_user.grand_admin?
      @entries = @q.result(distinct: true).all
    else
      @entries = @q.result(distinct: true).includes(:registration_number).where(registration_numbers: { dogrun_place_id: current_user.dogrun_place_id })
    end
  end
  
  def entries_ranking
    entries_count = Entry
      .includes(:registration_number)
      .where(registration_numbers: { dogrun_place_id: current_user.dogrun_place_id })
      .where(created_at: @one_year_ago.beginning_of_day..@today.end_of_day)
    return if entries_count.size <= 300
    
    entries_ranking = entries_count
      .group(:dog_id)
      .order('count_id DESC')
      .count.to_a

    @entries_ranking = []
    i = 0
    t = 0
    while i < 5
      @entries_ranking << [
        i + 1,
        Dog.find(entries_ranking[t][0]),
        entries_ranking[t][1]
      ]
      t += 1
      next if t >= 1 && entries_ranking[t - 1][1] == entries_ranking[t][1]
      i += 1
    end
  end

  private 
    def set_var
      @to = Time.current.at_end_of_day
      @from = (@to - 1.month)
      @today = Date.today
      @one_month_ago = @today.prev_day(30)
      @one_year_ago = @today.prev_day(365)
    end
end
