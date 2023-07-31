class Article < ApplicationRecord
  belongs_to :post
  has_one_attached :photo

  # validates
  validates :content, presence: true, length: { maximum: 400 }
  validates :photo, size: { less_than: 10.megabytes }, content_type: [:png, :jpg, :jpeg, :heif]

  # broadcast
  def create_broadcast
    broadcast_prepend_to [post.dogrun_place, "admin_posts_index"], target: "posts_dogrun_place_#{post.dogrun_place.id}", partial: "admin/posts/post", locals: { post: Post.find(self.post.id) }
    broadcast_replace_to [post.dogrun_place, "admin_navbar"], target: "new_post_count_badge_dogrun_place_#{post.dogrun_place.id}", partial: "admin/shared/new_post_count_badge", locals:{ current_user: User.where(role: "admin").find_by(dogrun_place: post.dogrun_place) }
    broadcast_replace_to [post.dogrun_place, "admin_sidebar"], target: "new_post_count_badge_dogrun_place_#{post.dogrun_place.id}", partial: "admin/shared/new_post_count_badge", locals: { current_user: User.where(role: "admin").find_by(dogrun_place: post.dogrun_place) }
  end
end

# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
