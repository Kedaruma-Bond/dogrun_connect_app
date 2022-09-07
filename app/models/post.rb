class Post < ApplicationRecord
  belongs_to :user
  belongs_to :dogrun_place
  belongs_to :postable, polymorphic: true, dependent: :destroy
  mount_uploader :attach_image, AttachmentUploader

  self.ignored_columns = %i[attach_image content]

  #validates

  # enum
  enum publish_status: { non_publish: false, is_publishing: true }

end

# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  publish_status  :boolean          default("non_publish"), not null
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
