require 'rails_helper'

RSpec.describe Article, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      article = build(:article)
      expect(article).to be_valid
    end
  end

  describe 'contentフィールドについて' do
    context 'nilの場合' do
      example '無効であること' do
        article = build(:article, content: nil)
        expect(article).to be_invalid
        expect(article.errors).to be_of_kind(:content, :blank)
      end
    end

    context '400字以上の場合' do
      example '無効であること' do
        article = build(:article, content: 'a' * 401)
        expect(article).to be_invalid
        expect(article.errors).to be_of_kind(:content, :too_long)
      end
    end
  end
  
  context 'postがnilの場合' do
    example '無効であること' do
      article = build(:article, post: nil)
      expect(article).to be_invalid
      expect(article.errors).to be_of_kind(:post, :blank)
    end
  end

  describe 'photoフィールドについて' do
    context 'サイズが10M以上の場合' do
      before do
        @article = build(:article)
        @article.photo = fixture_file_upload('/images/test_image.jpg')
      end
      example '無効であること' do
        expect(@article).to be_invalid
        expect(@article.errors).to be_of_kind(:photo, :file_size_out_of_range)
      end
    end

    context 'ファイル形式がtiffの場合' do
      before do
        @article = build(:article)
        @article.photo = fixture_file_upload('images/test_image_tiff.tiff')
      end
      example '無効であること' do
        expect(@article).to be_invalid
        expect(@article.errors).to be_of_kind(:photo, :content_type_invalid)
      end
    end

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
