class Reon::RegistrationNumbersController < Reon::DogrunPlaceController
  before_action :set_dogs, only: %i[new create]
  before_action :set_registration_number, only: %i[destroy entries_record_analysis]
  before_action :correct_registration_number_of_dog_owner, only: %i[destroy entries_record_analysis]

  def form_selection
    @confirmation = I18n.t('local.dog_registrations.form_selection.confirmation', registration_card: I18n.t('reon.registration_card'))
  end
  
  def have_registration_card
    session[:card_flg] = true
    redirect_to  send(@new_registration_number_path)
  end

  def not_have_registration_card
    session[:card_flg] = false
    redirect_to  send(@new_registration_number_path)
  end

  def new
    @registration_number_hint = I18n.t('local.dog_registrations.new.registration_number_hint', registration_card: I18n.t('reon.registration_card'))
    @registration_number = RegistrationNumber.new
  end

  def create
    @registration_number = RegistrationNumber.new(registration_number_params)
    if @dog_id.blank?
      @registration_number.errors.add(:dog, :unselected_option)
      render :new, status: :unprocessable_entity
      return
    end

    if @registration_number.valid?
      @registration_number.save!
      @registration_number.create_broadcast
      session.delete(:card_flg)
      respond_to do |format|
        format.html { redirect_to send(@user_path, current_user), success: t('local.registration_numbers.registered_successfully') }
        format.json { header :no_content }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @registration_number.destroy
    @registration_number.destroy_broadcast
    respond_to do |format|
      format.html { redirect_to send(@user_path, current_user), success: t('local.registration_numbers.destroy_successfully'), status: :see_other }
      format.turbo_stream { flash.now[:success] = t('local.registration_numbers.destroy_successfully') }
    end
  end

  def entries_record_analysis
    today = Date.today
    one_year_ago = today.prev_day(365)
    @entries_of_past_one_year = Entry.where(registration_number: @registration_number).where(created_at: one_year_ago..today.end_of_day)
    entries_monthly = @entries_of_past_one_year.map do |e|
      e.entry_at.strftime('%Y-%m')
    end

    entries_monthly = entries_monthly.each_with_object(Hash.new(0)){|v,o| o[v]+=1}
    all_months = (one_year_ago..today).to_a.map { |date| date.beginning_of_month }.uniq

    @entries_monthly = all_months.map do |month|
      month_key = month.strftime('%Y-%m')
      [month_key, entries_monthly[month_key] || 0]
    end.to_h 

    @notation_of_registration_number = I18n.t('reon.registration_number')

    render(
      RegistrationNumbers::EntriesRecordAnalysisComponent.new(
        registration_number: @registration_number,
        dog: @registration_number.dog,
        entries_of_past_one_year: @entries_of_past_one_year,
        entries_monthly: @entries_monthly,
        notation_of_registration_number: @notation_of_registration_number,
        dogrun_place: @dogrun_place
      ), content_type: "text/html")

  end
  
  private
  
    def set_dogs
      @dogs = []
      dogs = Dog.includes(:user).where(user: current_user)
      dogs.each do |dog|
        unless dog.registration_numbers.where(dogrun_place: @dogrun_place).present?
          @dogs << dog
        end
      end
    end

    def registration_number_params
      @dog_id = params[:registration_number][:select_dog]
      params.require(:registration_number).permit(
        :registration_number, :agreement
      ).merge(
        dog_id: @dog_id,
        dogrun_place_id: @dogrun_place.id
      )
    end

    def set_registration_number
      @registration_number = RegistrationNumber.find(params[:id])
    end

    def correct_registration_number_of_dog_owner
      dog = Dog.find(@registration_number.dog_id)
      user = User.find(dog.user_id)
      unless correct_user?(user, current_user)
        redirect_to '/', error: t('defaults.require_correct_account')
      end
    end

end
