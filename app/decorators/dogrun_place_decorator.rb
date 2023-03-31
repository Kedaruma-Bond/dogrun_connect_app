module DogrunPlaceDecorator
  def registration_card_preview
    Cloudinary::Utils.cloudinary_url(registration_card.key, gravity: :auto, quarity_auto: :good, fetch_format: :auto)
  end
end
