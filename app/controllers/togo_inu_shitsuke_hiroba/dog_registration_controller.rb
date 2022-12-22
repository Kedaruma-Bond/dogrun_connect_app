class TogoInuShitsukeHiroba::DogRegistrationController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :dog_registration_params, only: :confirm
  before_action :check_not_guest

  def new
    session.delete(:dog_registration_form)
    @dog_registration = DogRegistration.new
  end

  def confirm
    @dog_registration = DogRegistration.new(dog_registration_params)
    if @dog_registration.valid?
      session[:dog_registration_form] = dog_registration_params
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @dog_registration = DogRegistration.new(session[:dog_registration_form].to_hash)
    if params[:back]
      render :new, status: :unprocessable_entity
      return
    end

    if @dog_registration.save
      session.delete(:dog_registration_form)
      redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.dog_registration')
      return
    end
    render :new, status: :unprocessable_entity
  end

  private

  def dog_registration_params
    dogrun_place_id = @dogrun_place.id
    params.require(:dog_registration).permit(
      :name, :castration, :public,
      :registration_number
    ).merge(
      user_id: current_user.id,
      dogrun_place_id: dogrun_place_id
    )
  end
end
