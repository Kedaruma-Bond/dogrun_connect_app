require 'rails_helper'

RSpec.describe Facility, type: :model do
  context '全てのフィールドが有効な場合' do
    example '有効であること' do
      facility = build(:facility)
      expect(facility).to be_valid
    end
  end

  describe 'nameフィールドについて' do
    context 'nilの場合' do
      example '無効であること' do
        facility = build(:facility, name: nil)
        expect(facility).to be_invalid
        expect(facility.errors).to be_of_kind(:name, :blank)
      end
    end
  
    context '50字以上の場合' do
      example '無効であること' do
        facility = build(:facility, name: 'a' * 51)
        expect(facility).to be_invalid
        expect(facility.errors).to be_of_kind(:name, :too_long)
      end
    end
  end
end

# == Schema Information
#
# Table name: facilities
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
