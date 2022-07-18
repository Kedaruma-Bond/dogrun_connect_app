require 'rails_helper'

RSpec.describe Dog, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      dog = build(:dog, :castrated, :public_view, :male)
      expect(dog).to be_valid
    end
  end

  context 'nameが空欄の場合' do
    it '無効であること' do
      dog = build(:dog, :non_castrated, :non_public, name: nil)
      expect(dog).to be_invalid
      expect(dog.errors[:name]).to include('を入力してください')
    end
  end

  context 'castrationがnullの場合' do
    it '無効であること' do
      dog = build(:dog, :public_view, castration: nil)
      expect(dog).to be_invalid
      expect(dog.errors[:castration]).to include('を入力してください')
    end
  end

  context 'publicがnullの場合' do
    it '無効であること' do
      dog = build(:dog, :castrated, public: nil)
      expect(dog).to be_invalid
      expect(dog.errors[:public]).to include('を入力してください')
    end
  end
end

# == Schema Information
#
# Table name: dogs
#
#  id            :bigint           not null, primary key
#  birthday      :date
#  breed         :string           default("")
#  castration    :boolean          not null
#  name          :string           not null
#  owner_comment :text             default("")
#  public        :boolean          not null
#  sex           :integer
#  weight        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_dogs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
