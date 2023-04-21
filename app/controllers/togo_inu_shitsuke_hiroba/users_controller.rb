class TogoInuShitsukeHiroba::UsersController < TogoInuShitsukeHiroba::DogrunPlaceController
  before_action :set_new_post, only: %i[show]
  skip_before_action :require_login, only: %i[new create route_selection fully_route minimum_route]
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
    @registration_numbers_for_profile = @registration_numbers.map do |registration_number|
      registration_number.registration_number
    end
    @end = @dogs.size - 1
    @times = 0

    @num_of_encount_dogs = EncountDog.encount_dog_of_user(current_user).size
    
    # 5個以上重複したencount recordを削除
    user_dogs = Dog.where(user_id: current_user.id)
    t = 0
    user_dogs.count.times do |t|
      encounts = Encount.where(dogrun_place_id: @dogrun_place.id).where(dog_id: user_dogs[t].id)
      encounts.first.destroy! if encounts.count > 5
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :deactivation, :password, :password_confirmation,
      :agreement
    )
  end

end
