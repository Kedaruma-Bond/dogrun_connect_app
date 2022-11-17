class Article < ApplicationRecord
  belongs_to :post
  has_one_attached :photo

  self.ignored_columns = [:image_attach]

  # validates
  validates :content, presence: true, length: { maximum: 400 }
  validates :photo, size: { less_than: 10.megabytes }
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
