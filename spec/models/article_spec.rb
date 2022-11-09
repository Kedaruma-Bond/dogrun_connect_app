require 'rails_helper'

RSpec.describe Article, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      article = build(:article)
      expect(article).to be_valid
    end
  end
  
  context 'contentがnullの場合' do
    it '無効であること' do
      article = build(:article, content: nil)
      expect(article).to be_invalid
      expect(article.errors[:content]).to include('を入力してください')
    end
  end
  
  context 'postがnullの場合' do
    it '無効であること' do
      article = build(:article, post: nil)
      expect(article).to be_invalid
      expect(article.errors[:post]).to include('を入力してください')
    end
  end
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
