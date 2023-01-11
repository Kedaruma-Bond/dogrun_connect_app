class DogRegistration
  include ActiveModel::Model
  attr_accessor :name, :castration, :public, :user_id,
                :registration_number, :dogrun_place_id

  # validates
  with_options presence: true do
    validates :name, length: { maximum: 50 }
    validates :registration_number
    validates :user_id
    validates :dogrun_place_id
  end
  
  def save
    dog = Dog.create(name: name, castration: castration, public: public, user_id: user_id)
    RegistrationNumber.create!(registration_number: registration_number, dog_id: dog.id, dogrun_place_id: dogrun_place_id)
  end
end
