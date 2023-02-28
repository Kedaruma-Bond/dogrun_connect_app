require 'rails_helper'

RSpec.describe Post, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      post = build(:post, :non_publish, :article)
      expect(post).to be_valid
    end
  end

  context 'post_typeがnilの場合' do
    example '無効であること' do
      post = build(:post, :non_publish, post_type: nil)
      expect(post).to be_invalid
      expect(post.errors).to be_of_kind(:post_type, :blank)
    end
  end

  context 'publish_statusがnilの場合' do
    example '無効であること' do
      post = build(:post, :article, publish_status: nil)
      expect(post).to be_invalid
      expect(post.errors).to be_of_kind(:publish_status, :blank)
    end
  end

  context 'dogrun_placeがnilの場合' do
    example '無効であること' do
      post = build(:post, :article, :non_publish, dogrun_place: nil)
      expect(post).to be_invalid
      expect(post.errors).to be_of_kind(:dogrun_place, :blank)
    end
  end

  context 'userがnilの場合' do
    example '無効であること' do
      post = build(:post, :article, :non_publish, user: nil)
      expect(post).to be_invalid
      expect(post.errors).to be_of_kind(:user, :blank)
    end
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
