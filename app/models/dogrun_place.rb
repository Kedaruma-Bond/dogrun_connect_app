class DogrunPlace < ApplicationRecord
  has_many :administrators
  has_many :registration_numbers

end

# == Schema Information
#
# Table name: dogrun_places
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
