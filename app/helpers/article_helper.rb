module ArticleHelper
  def article_photo(article)
    cl_image_tag(article.photo.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, alt: "preview of article's photo", class: "object-cover mx-auto rounded-lg max-w-max-1/2 max-h-max-1/2")
  end

  def article_photo_for_preview(article)
    if !article.photo.nil? && article.photo.attached?
      cl_image_tag(article.photo.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, "data-preview-target": "imagePreview", alt: "preview of article's photo", class: "object-cover mx-auto rounded-lg max-w-max-1/2 max-h-max-1/2")
    else
      # 小さい画像ファイルを表示させておき、添付画像と差し替える
      image_tag 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==', "data-preview-target": "imagePreview"
    end
  end
end
