require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe 'validations' do
    context '全てのフィールドが有効な場合' do
      example '有効であること' do
        entry = build(:entry)
        expect(entry).to be_valid
      end
    end
  
    context 'dogがnilの場合' do
      example '無効であること' do
        entry = build(:entry, dog: nil)
        expect(entry).to be_invalid
        expect(entry.errors).to be_of_kind(:dog, :blank)
      end
    end
    
    context 'registration_numberがnilの場合' do
      example '無効であること' do
        entry = build(:entry, registration_number: nil)
        expect(entry).to be_invalid
        expect(entry.errors).to be_of_kind(:registration_number, :blank)
      end
    end
    
    context 'entry_atがnilの場合' do
      example '無効であること' do
        entry = build(:entry, entry_at: nil)
        expect(entry).to be_invalid
        expect(entry.errors).to be_of_kind(:entry_at, :blank)
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

    context 'scope :admin_dogrun_place_id' do
      let!(:entry1) { create(:entry, dog: dog1, registration_number: registration_number1, entry_at: Time.current - 1.day) }
      let!(:entry2) { create(:entry, dog: dog2, registration_number: registration_number2, entry_at: Time.current - 2.days) }
      let!(:entry3) { create(:entry, dog: dog1, registration_number: registration_number1, entry_at: Time.current - 3.days) }
      
      example '正常に動作すること' do
        expect(Entry.admin_dogrun_place_id(dogrun_place.id)).to eq([entry1, entry2, entry3])
      end
    end
    
    context 'scope :dogrun_place_id' do
      let!(:entry1) { create(:entry, dog: dog1, registration_number: registration_number1, entry_at: Time.current - 1.day) }
      let!(:entry2) { create(:entry, dog: dog2, registration_number: registration_number2, entry_at: Time.current - 2.days) }
      
      example '正常に動作すること' do
        expect(Entry.dogrun_place_id(dogrun_place.id)).to eq([entry1])
      end
    end
    
    context 'scope :user_id' do
      let!(:entry1) { create(:entry, dog: dog1, registration_number: registration_number1, entry_at: Time.current - 1.day) }
      let!(:entry2) { create(:entry, dog: dog2, registration_number: registration_number2, entry_at: Time.current - 2.days) }
      
      example '正常に動作すること' do
        expect(Entry.user_id(user.id)).to eq([entry1, entry2])
      end
    end
    
    context 'scope :user_id_at_local' do
      let!(:entry1) { create(:entry, dog: dog1, registration_number: registration_number1, entry_at: Time.current - 1.day) }
      let!(:entry2) { create(:entry, dog: dog2, registration_number: registration_number2, entry_at: Time.current - 2.days) }
      
      example '正常に動作すること' do
        expect(Entry.user_id_at_local(user.id)).to eq([entry1, entry2])
      end
    end

  end
end

# == Schema Information
#
# Table name: entries
#
#  id                     :bigint           not null, primary key
#  entry_at               :datetime         not null
#  exit_at                :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  dog_id                 :bigint           not null
#  registration_number_id :bigint           not null
#
# Indexes
#
#  index_entries_on_dog_id                  (dog_id)
#  index_entries_on_registration_number_id  (registration_number_id)
#  registration_dog_entry_time_index        (dog_id,registration_number_id,entry_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (dog_id => dogs.id)
#  fk_rails_...  (registration_number_id => registration_numbers.id)
#
