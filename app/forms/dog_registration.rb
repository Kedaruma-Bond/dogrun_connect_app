class DogRegistration
  include ActiveModel::Model
  attr_accessor :name, :castration, :public,
                :dogrun_place, :registration_number
  

end
