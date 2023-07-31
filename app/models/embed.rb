class Embed < ApplicationRecord
  belongs_to :post
  
  # validates
  validates :identifier, length: { maximum: 10000 }, presence: true
  validates :embed_type, presence: true

  # enum
  enum embed_type: { fb: 0, instagram: 1, twitter: 2}

  # broadcast
  def create_broadcast
    broadcast_prepend_to [post.dogrun_place, "admin_posts_index"], target: "posts_dogrun_place_#{post.dogrun_place.id}", partial: "admin/posts/post", locals: { post: Post.find(self.post.id) }
    broadcast_replace_to [post.dogrun_place, "admin_navbar"], target: "new_post_count_badge_dogrun_place_#{post.dogrun_place.id}", partial: "admin/shared/new_post_count_badge", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: post.dogrun_place) }
    broadcast_replace_to [post.dogrun_place, "admin_sidebar"], target: "new_post_count_badge_dogrun_place_#{post.dogrun_place.id}", partial: "admin/shared/new_post_count_badge", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: post.dogrun_place) }
  end
end

# == Schema Information
#
# Table name: embeds
#
#  id         :bigint           not null, primary key
#  embed_type :integer          not null
#  identifier :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#
# Indexes
#
#  index_embeds_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
