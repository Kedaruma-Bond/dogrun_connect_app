class Article < ApplicationRecord
  belongs_to :post
  mount_uploader :image_attach, AttachmentUploader
  has_one_attached :as_image_attach

  # validates
  validates :content, presence: true, length: { maximum: 400 }

  after_commit do
    update_active_storage if previous_changes.keys.include?('image_attach')
  end

  def update_active_storage
    self.as_image_attach.purge if self.as_image_attach.attached?
    sync_image_attach if self.image_attach.present?
  end

  def sync_image_attach
    image = self.image_attach
    image.cache_stored_file!
    file = image.sanitized_file.file
    content_type = image.content_type
    self.as_image_attach.attach(io: file, content_type: content_type, filename: self.attributes['image_attach'])
  end
end

# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  content      :text             not null
#  image_attach :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  post_id      :bigint           not null
#
# Indexes
#
#  index_articles_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
