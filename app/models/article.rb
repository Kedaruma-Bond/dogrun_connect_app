class Article < ApplicationRecord
  belongs_to :post
  mount_uploader :image_attach, AttachmentUploader
  has_one_attached :photo

  # validates
  validates :content, presence: true, length: { maximum: 400 }

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
