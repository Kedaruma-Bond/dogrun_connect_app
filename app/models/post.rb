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
