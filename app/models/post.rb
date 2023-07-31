class Post < ApplicationRecord
  belongs_to :user
  belongs_to :dogrun_place
  has_one :article, dependent: :destroy
  has_one :embed, dependent: :destroy

  #validates
  with_options on: %i[create update] do
    validates :post_type, presence: true
    validates :publish_status, presence: true
  end

  # enum
  enum publish_status: { non_publish: false, is_publishing: true }
  enum post_type: { article: 0, embed: 1 }

  # broadcast
  def remove_new_badge
    broadcast_replace_to [dogrun_place, "admin_posts_index"], target: "post_#{self.id}", partial: "admin/posts/post", locals: { post: self}
  end

  def destroy_broadcast
    broadcast_replace_to [dogrun_place, "admin_navbar"], target: "new_post_count_badge_dogrun_place_#{dogrun_place.id}", partial: "admin/shared/new_post_count_badge", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: dogrun_place) }
    broadcast_replace_to [dogrun_place, "admin_sidebar"], target: "new_post_count_badge_dogrun_place_#{dogrun_place.id}", partial: "admin/shared/new_post_count_badge", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: dogrun_place) }
  end

  # ransack authorization
  def self.ransackable_attributes(auth_object = nil)
    ["acknowledge", "created_at", "dogrun_place_id", "id", "post_type", "publish_limit", "publish_status", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["article", "dogrun_place", "embed", "user"]
  end
  
end

# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  acknowledge     :boolean          default(FALSE)
#  post_type       :integer          not null
#  publish_limit   :datetime
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
