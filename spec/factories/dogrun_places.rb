FactoryBot.define do
  factory :dogrun_place do
    sequence(:name) { |n| "Dogrun_Place_#{n}" }

    after(:create) do |dogrun_place|
      create_list(:dogrun_place_facility_relation, 1, dogrun_place: dogrun_place, facility: create(:facility))
    end

    trait :grand_admin do
      id { '1' }
      name { 'grand_admin' }
    end

    trait :togo_inu_shitsuke_hiroba do
      id { '2' }
      name { '犬のしつけ広場' }
    end
    
    trait :reon do
      id { '3' }
      name { '里音(Re:on)' }
    end
  end
end

# == Schema Information
#
# Table name: dogrun_places
#
#  id              :bigint           not null, primary key
#  address         :string           default("")
#  closed_flag     :boolean          default(FALSE)
#  closing_time    :time
#  description     :text             default("")
#  force_closed    :boolean          default("releasing")
#  name            :string           not null
#  opening_time    :time
#  prefecture_code :integer
#  site_area       :string           default("")
#  usage_fee       :string           default("")
#  web_site        :string           default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
