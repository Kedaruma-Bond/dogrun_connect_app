class Admin::DashboardsController < Admin::BaseController
  before_action :check_grand_admin, only: %i[grand_admin_index]
  before_action :set_var, only: %i[grand_admin_index index graph_section entries_ranking]

  def index
    @entries_over_the_past_month = Entry.where(entry_at: @from..@to).joins(:registration_number).where(registration_number: { dogrun_place_id: current_user.dogrun_place_id })
    @registration_dogs = RegistrationNumber.where(dogrun_place: current_user.dogrun_place)
    @new_registration_dogs_over_the_past_month = RegistrationNumber.where(dogrun_place_id: current_user.dogrun_place_id).where(created_at: @from..@to)

  end

  def grand_admin_index
    @entries_over_the_past_month = Entry.where(entry_at: @from..@to)
    @users = User.all
    @registration_dogs = Dog.all
    @new_registration_dogs_over_the_past_month = Dog.where(created_at: @from..@to)
  end

  def entries_count
    @q = Entry.ransack(params[:q])
    return @entries = nil if params[:q].blank?

    if current_user.grand_admin?
      @entries = @q.result.all
    else
      @entries = @q.result.includes(:registration_number).where(registration_numbers: { dogrun_place_id: current_user.dogrun_place_id })
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

    p "*" * 10
    p entries_ranking
    p "*" * 10
    

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

    p "*" * 10
    p @entries_ranking
    p "*" * 10

  end

  def graph_section
    if current_user.grand_admin?
      entries = Entry.all.where(created_at: @one_year_ago..@today.end_of_day)
    else
      entries = Entry.includes(:registration_number).where(registration_number: { dogrun_place_id: current_user.dogrun_place_id }).where(created_at: @one_year_ago..@today.end_of_day)
    end

    entries_daily = entries.map do |e|
      e.entry_at.strftime('%Y%m%d')
    end

    @entries_daily = (@one_month_ago..@today).map do |date|
      [date.strftime('%Y%m%d'), entries_daily.count(date.strftime('%Y%m%d'))]
    end.to_h

    entries_monthly = entries.map do |e|
      e.entry_at.strftime('%Y-%m')
    end

    entries_monthly = entries_monthly.each_with_object(Hash.new(0)){|v,o| o[v]+=1}
    all_months = (@one_year_ago..@today).to_a.map { |date| date.beginning_of_month }.uniq

    @entries_monthly = all_months.map do |month|
      month_key = month.strftime('%Y-%m')
      [month_key, entries_monthly[month_key] || 0]
    end.to_h 
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
