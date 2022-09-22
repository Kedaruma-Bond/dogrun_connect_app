class Embed < ApplicationRecord
  belongs_to :post
  
  # validates
  validates :identifier, length: { maximum: 10000 }, presence: true
  validates :embed_type, presence: true

  # enum
  enum embed_type: { fb: 0, instagram: 1, twitter: 2}
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
