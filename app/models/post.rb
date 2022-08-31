class Post < ApplicationRecord
  belongs_to :user
  belongs_to :dogrun_place
  mount_uploader :attach_image, AttachmentUploader

  #validates
  validates :content, presence: true, length: { maximum: 400 }

end

# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  attach_image    :string
#  content         :text             not null
#  publish_status  :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dogrun_place_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_posts_on_dogrun_place_id  (dogrun_place_id)
#  index_posts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#  fk_rails_...  (user_id => users.id)
#
