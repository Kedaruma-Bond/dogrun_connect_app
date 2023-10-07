require 'active_support'

module DashboardConcern
  extend ActiveSupport::Concern

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
      t('admin.dashboards.sex_type_ratio_graph.not_answered') => sex_type_ratio.find{|x| x[0].blank?}&.[](1),
      t('enums.dog.sex.male') => sex_type_ratio.find{|x| x[0] == "male"}&.[](1),
      t('enums.dog.sex.female') => sex_type_ratio.find{|x| x[0] == "female"}&.[](1),
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
