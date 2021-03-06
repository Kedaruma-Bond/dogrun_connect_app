class TogoInuShitsukeHiroba::UsersController < TogoInuShitsukeHiroba::DogrunPlaceController
  layout 'togo_inu_shitsuke_hiroba'
  skip_before_action :require_login, only: %i[new create]
  before_action :user_params, only: %i[create]
  before_action :set_dogs, :set_registration_numbers_in_togo_inu_shitsuke_hiroba, only: %i[show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.user_registration_success(@user).deliver_now
      login(params[:user][:email], params[:user][:password])
      redirect_to togo_inu_shitsuke_hiroba_dog_registration_path, success: t('.user_create')
      return
    end
    render :new, status: :unprocessable_entity
  end

  def show
    @registration_numbers_for_profile = []
    @registration_numbers.each do |registration_number|
      @registration_numbers_for_profile << registration_number.registration_number
    end
    @end = @dogs.size - 1
    @times = 0
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :deactivation, :enable_notification, :password, :password_confirmation,
      :agreement
    )
  end
end
