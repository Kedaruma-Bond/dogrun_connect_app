module ArticleHelper
  def photo_for_preview(article)
    if article.photo.attached?
      image_tag article.photo, "data-preview-target": "imagePreview", alt: "preview of article's photo", class: "object-cover mx-auto max-w-max-1/2 max-h-max-1/2"
    else
      image_tag 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==', "data-preview-target": "imagePreview", alt: "preview of article's photo"
    end
  end
end
