FactoryBot.define do
  factory :dogrun_place do
    sequence(:name) { |n| "Dogrun_Place_#{n}" }

    trait :togo_inu_shitsuke_hiroba do
      id { '2' }
      name { 'togo_inu_shitsuke_hiroba' }
    end
    
  end
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
