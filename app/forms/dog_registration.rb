class DogRegistration
  include ActiveModel::Model
  attr_accessor :name, :castration, :public, :user_id,
                :dogrun_place, :registration_number

  with_options presence: true do
    validates :name, length: { maximum: 50 }
    validates :user_id
    validates :registration_number
  end

  def save
    dog = Dog.create(name: name, castration: castration, public: public, user_id: user_id)
    RegistrationNumber.create!(dogrun_place: dogrun_place, registration_number: registration_number, dog_id: dog.id)
  end
end
