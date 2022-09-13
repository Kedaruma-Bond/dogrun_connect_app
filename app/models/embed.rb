class Embed < ApplicationRecord
  has_one :post, as: :postable, dependent: :destroy
  
  # validates
  validates :identifier, length: { maximum: 200 }
  validates :embed_type, presence: true

  # enum
  enum embed_type: { fb_insta: 0, twitter: 1}
end

# == Schema Information
#
# Table name: embeds
#
#  id         :bigint           not null, primary key
#  embed_type :integer          default(0), not null
#  identifier :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
