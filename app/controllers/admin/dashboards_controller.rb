class Admin::DashboardsController < Admin::BaseController
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

    def set_registration_dogs
      if current_user.grand_admin?
        @registration_dogs = Dog.all
      else
        @registration_dogs = Dog.includes(:registration_numbers).where(registration_numbers: { dogrun_place: current_user.dogrun_place } )
      end
    end

    def set_entries_of_past_one_year
      if current_user.grand_admin?
        @entries_of_past_one_year = Entry.all.where(created_at: @one_year_ago..@today.end_of_day)
      else
        @entries_of_past_one_year = Entry.includes(:registration_number).where(registration_number: { dogrun_place_id: current_user.dogrun_place_id }).where(created_at: @one_year_ago..@today.end_of_day)
      end
    end

    def sex_type_ratio_graph
      sex_type_ratio = @registration_dogs
        .group(:sex).count.to_h

      @sex_type_ratio = {
        t('admin.dashboards.sex_type_ratio_graph.not_answered') => sex_type_ratio.find{|x| x[0].nil?}[1],
        t('enums.dog.sex.male') => sex_type_ratio.find{|x| x[0] == "male"}[1],
        t('enums.dog.sex.female') => sex_type_ratio.find{|x| x[0] == "female"}[1],
      }
    end

    def daily_entries_graph
      entries_daily = @entries_of_past_one_year.map do |e|
        e.entry_at.strftime('%Y%m%d')
      end

      @entries_daily = (@one_month_ago..@today).map do |date|
        [date.strftime('%Y%m%d'), entries_daily.count(date.strftime('%Y%m%d'))]
      end.to_h
    end

    def monthly_entries_graph
      entries_monthly = @entries_of_past_one_year.map do |e|
        e.entry_at.strftime('%Y-%m')
      end

      entries_monthly = entries_monthly.each_with_object(Hash.new(0)){|v,o| o[v]+=1}
      all_months = (@one_year_ago..@today).to_a.map { |date| date.beginning_of_month }.uniq

      @entries_monthly = all_months.map do |month|
        month_key = month.strftime('%Y-%m')
        [month_key, entries_monthly[month_key] || 0]
      end.to_h 
    end

end
