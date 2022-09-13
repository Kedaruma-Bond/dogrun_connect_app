class Post < ApplicationRecord
  belongs_to :user
  belongs_to :dogrun_place
  belongs_to :postable, polymorphic: true, dependent: :destroy
  mount_uploader :attach_image, AttachmentUploader

  self.ignored_columns = %i[attach_image content]

  #validates
  with_options on: %i[create update] do
    validates :postable_type, presence: true
    validates :postable_id, presence: true
  end

  # enum
  enum publish_status: { non_publish: false, is_publishing: true }

  class << self

    def postable_types
      %w[Article Embed]
    end

    def valid_postable_type?(type)
      postable_types.include?(type.to_s.classify)
    end
  end

  def article?
    postable.is_a?(Article)
  end

  def embed?
    postable.is_a?(Embed)
  end

  def create_postable!(type)
    case type.to_s.classify
    when 'Article'
      self.postable = Article.create!
    when 'Embed'
      self.postable = Embed.create!
    else
      raise t('.post_type_error', type: type)
    end
    postable
  end
end

# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  postable_type   :string
#  publish_status  :boolean          default("non_publish"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dogrun_place_id :bigint           not null
#  postable_id     :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_posts_on_dogrun_place_id  (dogrun_place_id)
#  index_posts_on_postable         (postable_type,postable_id)
#  index_posts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#  fk_rails_...  (user_id => users.id)
#
