require 'rails_helper'

RSpec.describe Embed, type: :model do
  
  describe 'type: twitter' do
    context '全てのフィールドが有効な場合' do
      example '有効であること' do
        embed = build(:embed, :twitter)
        expect(embed).to be_valid
      end
    end

    context 'embed_typeがnilの場合' do
      example '無効であること' do
        embed = build(:embed, :twitter, embed_type: nil)
        expect(embed).to be_invalid
        expect(embed.errors[:embed_type]).to include('を入力してください')
      end
    end

    context 'identifierがnilの場合' do
      example '無効であること' do
        embed = build(:embed, :twitter, identifier: nil)
        expect(embed).to be_invalid
        expect(embed.errors[:identifier]).to include('を入力してください')
      end
    end
  end

  describe 'type: instagram' do
    context '全てのフィールドが有効な場合' do
      example '有効であること' do
        embed = build(:embed, :instagram)
        expect(embed).to be_valid
      end
    end

    context 'embed_typeがnilの場合' do
      example '無効であること' do
        embed = build(:embed, :instagram, embed_type: nil)
        expect(embed).to be_invalid
        expect(embed.errors[:embed_type]).to include('を入力してください')
      end
    end

    context 'identifierがnilの場合' do
      example '無効であること' do
        embed = build(:embed, :instagram, identifier: nil)
        expect(embed).to be_invalid
        expect(embed.errors[:identifier]).to include('を入力してください')
      end
    end
  end

  describe 'type: fb' do
    context '全てのフィールドが有効な場合' do
      example '有効であること' do
        embed = build(:embed, :fb)
        expect(embed).to be_valid
      end
    end
    
    context 'embed_typeがnilの場合' do
      example '無効であること' do
        embed = build(:embed, :fb, embed_type: nil)
        expect(embed).to be_invalid
        expect(embed.errors[:embed_type]).to include('を入力してください')
      end
    end

    context 'identifierがnilの場合' do
      example '無効であること' do
        embed = build(:embed, :fb, identifier: nil)
        expect(embed).to be_invalid
        expect(embed.errors[:identifier]).to include('を入力してください')
      end
    end
  end
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
