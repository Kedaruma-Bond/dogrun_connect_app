class Article < ApplicationRecord
  has_one :post, as: :postable, dependent: :destroy
  mount_uploader :image_attach, AttachmentUploader

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
#
