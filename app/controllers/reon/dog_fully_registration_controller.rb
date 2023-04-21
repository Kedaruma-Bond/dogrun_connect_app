class Reon::DogFullyRegistrationController < Reon::DogrunPlaceController
  before_action :set_new_post, only: %i[new]
  before_action :check_not_guest

  def form_selection
    @confirmation = I18n.t('local.dog_registrations.form_selection.confirmation', registration_card: I18n.t('reon.registration_card'))
  end

  def have_registration_card
    session[:card_flg] = true
    redirect_to send(@dog_fully_registration_path)
  end

  def not_have_registration_card
    session[:card_flg] = false
    redirect_to send(@dog_fully_registration_path)
  end

  def new
    @registration_number_hint = I18n.t('local.dog_registrations.new.registration_number_hint', registration_card: I18n.t('reon.registration_card'))
    session.delete(:dog_fully_registration_form)
    @dog_fully_registration = DogFullyRegistration.new
  end

  def create
    @dog_fully_registration = DogFullyRegistration.new(dog_fully_registration_params)
    if @dog_fully_registration.valid? 
      @dog_fully_registration.save
      session.delete(:card_flg)
      session.delete(:fully_flg)
      redirect_to send(@top_path), success: t('local.dog_registrations.dog_registration')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def dog_fully_registration_params
      params.require(:dog_fully_registration).permit(
        :name, :birthday, :breed, :castration, :public,
        :owner_comment, :sex, :weight,
        :thumbnail, :mixed_vaccination_certificate, :rabies_vaccination_certificate, :license_plate,
        :date_of_mixed_vaccination, :date_of_rabies_vaccination, :registration_prefecture_code,
        :registration_municipality, :municipal_registration_number,
        :registration_number, :agreement
      ).merge(
        user_id: current_user.id,
        dogrun_place_id: @dogrun_place.id
      )
    end
end
