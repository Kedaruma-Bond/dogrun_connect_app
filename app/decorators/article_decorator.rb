module ArticleDecorator
  def photo_preview
    cl_image_path photo.key, gravity: :auto, quality_auto: :good, fetch_format: :auto
  end
end
