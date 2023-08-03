class DogFullyRegistration
  include ActiveModel::Model

  include JpPrefecture
  jp_prefecture :registration_prefecture_code, method_name: :pref

  attr_accessor :name, :thumbnail, :castration, :public, :birthday, :breed, :sex, :weight, :mixed_vaccination_certificate, :date_of_mixed_vaccination, :rabies_vaccination_certificate, :date_of_rabies_vaccination, :registration_prefecture_code, :registration_municipality, :municipal_registration_number, :license_plate, :user_id,
                :registration_number, :dogrun_place_id, :agreement

  # validates
  with_options presence: true do
    validates :name, length: { maximum: 50 }
    validates :breed, length: { maximum: 50 }
    validates :weight, numericality: { greater_than: 0 }
    validates :registration_municipality, length: { maximum: 30 }
    validates :municipal_registration_number, length: { maximum: 10 }
  end
  validates :agreement, acceptance: true
  validates :sex, presence: true
  validates :birthday, presence: true
  validates :date_of_rabies_vaccination, presence: true
  validates :date_of_mixed_vaccination, presence: true
  validates :registration_prefecture_code, presence: true
  validates :registration_number, presence: true
  validates :user_id, presence: true
  validates :dogrun_place_id, presence: true
  validate :validate_attachment, :validate_file_size, :validate_content_type

  def save
    dog = Dog.new(
      name: name,
      castration: castration,
      public: public,
      birthday: birthday,
      breed: breed,
      sex: Dog.sexes[sex.to_sym],
      weight: weight,
      date_of_rabies_vaccination: date_of_rabies_vaccination,
      date_of_mixed_vaccination: date_of_mixed_vaccination,
      registration_prefecture_code: registration_prefecture_code,
      registration_municipality: registration_municipality,
      municipal_registration_number: municipal_registration_number,
      user_id: user_id
    )
    dog.thumbnail.attach(thumbnail)
    dog.rabies_vaccination_certificate.attach(rabies_vaccination_certificate)
    dog.mixed_vaccination_certificate.attach(mixed_vaccination_certificate)
    dog.license_plate.attach(license_plate)

    dog.save!
    
    RegistrationNumber.create!(
      registration_number: registration_number,
      dog_id: dog.id,
      dogrun_place_id: dogrun_place_id
    )
    RegistrationNumber.where(dog_id: dog.id).find_by(dogrun_place_id: dogrun_place_id).create_broadcast
  end

  private
    def validate_attachment
      [:thumbnail, :rabies_vaccination_certificate, :mixed_vaccination_certificate, :license_plate].each do |field|
        attachment = send(field)
        if attachment.nil?
          errors.add(field, :not_attached)
        end
      end
    end

    def validate_file_size
      [:thumbnail, :rabies_vaccination_certificate, :mixed_vaccination_certificate, :license_plate].each do |field|
        attachment = send(field)
        if !attachment.nil? && attachment.size > 10.megabytes
          errors.add(field, :file_size_out_of_range)
        end
      end
    end

    def validate_content_type
      [:thumbnail, :rabies_vaccination_certificate, :mixed_vaccination_certificate, :license_plate].each do |field|
        attachment = send(field)
        if !attachment.nil?
          errors.add(field, :content_type_invalid) unless attachment.content_type.in?(%w[image/png image/jpg image/jpeg image/heif])
        end
      end
    end
end
