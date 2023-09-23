class TogoInuShitsukeHiroba::UsersController < TogoInuShitsukeHiroba::DogrunPlaceController
  skip_before_action :require_login, :is_account_deactivated?, only: %i[new create route_selection fully_route minimum_route]
  before_action :correct_user, :set_dogs_and_registration_numbers_at_local, only: %i[show]

  def route_selection; end

  def fully_route
    session[:fully_flg] = true
    redirect_to send(@signup_path)
  end

  def minimum_route
    session[:fully_flg] = false
    redirect_to send(@signup_path)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.user_registration_success(@user).deliver_now
      login(params[:user][:email], params[:user][:password])
      case session[:fully_flg]
      when true
        redirect_to send(@signup_fully_route_user_detail_path), notice: t('local.users.make_user_detail')
      else
        if @dogrun_place.registration_card.blank?
          redirect_to send(@dog_registration_path), success: t('local.users.user_create')
        else
          redirect_to send(@form_selection_path), success: t('local.users.user_create')
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @notation_of_registration_number = I18n.t('togo_inu_shitsuke_hiroba.registration_number')
    @num_of_encount_dogs = EncountDog.encount_dog_of_user(current_user).size
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :deactivation, :password, :password_confirmation,
      :agreement
    )
  end

end
