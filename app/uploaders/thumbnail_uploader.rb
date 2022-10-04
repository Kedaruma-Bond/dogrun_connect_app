class ThumbnailUploader < CarrierWave::Uploader::Base
  
  if Rails.env.production?
    include Cloudinary::CarrierWave
    include ::CarrierWave::Backgrounder::Delay

    CarrierWave.configure do |config|
      config.cache_storage = :file
    end
    
    process convert: 'png'
    process tags: ['dog_thumbnail']
  else
    include CarrierWave::MiniMagick
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'https://res.cloudinary.com/hryerpkcw/image/upload/v1661501955/thumbnail_placeholder_ztqnju.png'
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :std_thumb do
    if Rails.env.production?
      process eager: true
      cloudinary_transformation aspect_ratio: 1.0, crop: :fill, gravity: :auto, radius: :max, quality_auto: :good, fetch_format: :auto  
    end
  end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg gif png heic)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def size_range
    1..10.megabytes
  end


  def public_id
    return model.name
  end

end
