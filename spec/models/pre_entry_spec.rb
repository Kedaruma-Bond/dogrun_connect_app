require 'rails_helper'

RSpec.describe PreEntry, type: :model do
  describe 'validations' do
    context '全てのフィールドが有効な場合' do
      example '有効であること' do
        pre_entry = build(:pre_entry)
        expect(pre_entry).to be_valid
      end
    end
  
    context 'minutes_passed_countがnillの場合' do
      example '無効であること' do
        pre_entry = build(:pre_entry, minutes_passed_count: nil)
        expect(pre_entry).to be_invalid
        expect(pre_entry.errors).to be_of_kind(:minutes_passed_count, :blank)
      end
    end
  
    context 'dogがnilの場合' do
      example '無効であること' do
        pre_entry = build(:pre_entry, dog: nil)
        expect(pre_entry).to be_invalid
        expect(pre_entry.errors).to be_of_kind(:dog, :blank)
      end
    end
  
    context 'registration_numberがnilの場合' do
      example '無効であること' do
        pre_entry = build(:pre_entry, registration_number: nil)
        expect(pre_entry).to be_invalid
        expect(pre_entry.errors).to be_of_kind(:registration_number, :blank)
      end
    end
  end

  describe 'delegations' do
    it { should delegate_method(:dogrun_place).to(:registration_number) }
  end

  describe 'scope' do
    let(:user) { create(:user) }
    let(:dogrun_place) { create(:dogrun_place) }
    let(:dog1) { create(:dog, user: user, castration: 'castrated', public: 'public_view') }
    let(:dog2) { create(:dog, user: user, castration: 'castrated', public: 'non_public') }
    let(:registration_number1) { create(:registration_number, dog: dog1, dogrun_place: dogrun_place) }
    let(:registration_number2) { create(:registration_number, dog: dog2, dogrun_place: dogrun_place) }

    context 'scope :user_id_at_local' do
      let!(:pre_entry1) { create(:pre_entry, dog: dog1, registration_number: registration_number1) }
      let!(:pre_entry2) { create(:pre_entry, dog: dog2, registration_number: registration_number2) }

      example '正常に動作すること' do
        expect(PreEntry.user_id_at_local(user.id)).to eq([pre_entry1, pre_entry2])
      end
    end
  end
end

# == Schema Information
#
# Table name: pre_entries
#
#  id                     :bigint           not null, primary key
#  minutes_passed_count   :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  dog_id                 :bigint           not null
#  registration_number_id :bigint           not null
#
# Indexes
#
#  index_pre_entries_on_dog_id                  (dog_id)
#  index_pre_entries_on_registration_number_id  (registration_number_id)
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (registration_number_id => registration_numbers.id)
#
