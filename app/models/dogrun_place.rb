class DogrunPlace < ApplicationRecord
  has_many :registration_numbers
  has_many :posts, dependent: :destroy
  has_many :staffs, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :friend_dogs, dependent: :destroy

end

# 1: grand_admin
# 2: 犬のしつけ広場

# == Schema Information
#
# Table name: dogrun_places
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
