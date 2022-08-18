class DogrunPlace < ApplicationRecord
  has_many :administrators
  has_many :registration_numbers

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
