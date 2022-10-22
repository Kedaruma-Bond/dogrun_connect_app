FactoryBot.define do
  factory :post do
    association :dogrun_place
    association :user

    trait :is_publishing do
      publish_status { 'is_publishing' }
    end

    trait :non_publish do
      publish_status { 'non_publish' }
    end

    trait :article do
      post_type { 'article' }
    end

    trait :embed do
      post_type { 'embed' }
    end
  end
end

# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
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
