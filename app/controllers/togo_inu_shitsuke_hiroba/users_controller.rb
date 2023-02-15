class TogoInuShitsukeHiroba::UsersController < TogoInuShitsukeHiroba::DogrunPlaceController
  skip_before_action :require_login, only: %i[new create]
  before_action :correct_user, :set_dogs_and_registration_numbers_at_local, only: %i[show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.user_registration_success(@user).deliver_now
      login(params[:user][:email], params[:user][:password])
      redirect_to send(@dog_registration_path), success: t('local.users.user_create')
      return
    end
    render :new, status: :unprocessable_entity
  end

  def edit
    @user = User.find(params[:id])
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
