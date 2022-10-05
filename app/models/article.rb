class Article < ApplicationRecord
  belongs_to :post
  mount_uploader :image_attach, AttachmentUploader
  process_in_background :image_attach
  store_in_background :image_attach

  # validates
  validates :content, presence: true, length: { maximum: 400 }

end

# == Schema Information
#
# Table name: articles
#
#  id               :bigint           not null, primary key
#  content          :text             not null
#  image_attach     :string
#  image_attach_tmp :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  post_id          :bigint           not null
#
# Indexes
#
#  index_articles_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
