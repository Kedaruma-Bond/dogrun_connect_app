require 'rails_helper'

RSpec.describe Entry, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      entry = build(:entry)
      expect(entry).to be_valid
    end
  end

  context 'entry_atが空欄の場合' do
    it '無効であること' do
      entry = build(:entry, entry_at: nil)
      expect(entry).to be_invalid
      expect(entry.errors[:entry_at]).to include('を入力してください')
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
