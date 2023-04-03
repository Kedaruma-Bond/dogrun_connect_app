class SnsAccount < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :dogrun_place, optional: true
  include ActiveModel::Validations

  # validations
  validates_with SnsAccountValidator
end

# == Schema Information
#
# Table name: sns_accounts
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dogrun_place_id :bigint
#  facebook_id     :string
#  instagram_id    :string
#  twitter_id      :string
#  user_id         :bigint
#
# Indexes
#
#  index_sns_accounts_on_dogrun_place_id  (dogrun_place_id)
#  index_sns_accounts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#  fk_rails_...  (user_id => users.id)
#
