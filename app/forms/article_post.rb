class ArticlePost
  include ActiveModel::Model
  attr_accessor :post_type, :publish_status, :user_id, :dogrun_place_id,
                :content, :photo

  # validates
  with_options presence: true do
    validates :user_id
    validates :dogrun_place_id
    validates :post_type
    validates :publish_status
    validates :content, length: { maximum: 400 }
  end
  validate :validate_file_size, :validate_content_type

  def save 
    post = Post.new(
      post_type: Post.post_types[post_type.to_sym],
      publish_status: publish_status,
      user_id: user_id,
      dogrun_place_id: dogrun_place_id
    )

    post.save!
  
    article = Article.new(
      content: content,
      post_id: post.id
    )
    article.photo.attach(photo)

    article.save!
    article.create_broadcast
  end

  private
    def validate_file_size
      attachment = send(:photo)
      return if attachment.nil?
      if attachment.size > 10.megabytes
        errors.add(:photo, :file_size_out_of_range)
      end
    end

    def validate_content_type
      attachment = send(:photo)
      return if attachment.nil?
      errors.add(:photo, :content_type_invalid) unless attachment.content_type.in?(%w[image/png image/jpg image/jpeg image/heif])
    end
end
