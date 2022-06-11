class SignupForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name, :email, :password, :password_confirmation, :deactivation, :enable_notification,
                :dog_name, :castration, :public, :breed, :owner_comment, :birthday,
                :dogrun_place, :registration_number

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  # email uniqueness: trueのvalidationができなかったので苦肉の策
  validate :email_is_unique
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :deactivation, presence: true
  validates :enable_notification, presence: true

  validates :dog_name, presence: true, length: { maximum: 50 }
  validates :breed, length: { maximum: 50 }
  validates :owner_comment, length: { maximum: 400 }

  validates :dogrun_place, presence: true
  validates :registration_number, presence: true

  def save
    user = User.create(
      name: name, email: email, password: password, password_confirmation: password_confirmation,
      deactivation: deactivation, enable_notification: enable_notification
    )
    dog = Dog.create(
      dog_name: dog_name, castration: castration, public: public, birthday: birthday,
      owner_comment: owner_comment, user_id: user.id
    )
    dogrun_place = dogrun_place.to_i
    RegistrationNumber.create(dogrun_place: dogrun_place, registration_number: registration_number, dog_id: dog.id)
  end

  private

  def email_is_unique
    return if User.where(email: email).count.zero?

    errors.add(:email, '入力されたメールアドレスはすでに使用されています')
  end
end
