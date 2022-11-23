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
#  id              :bigint           not null, primary key
#  address         :string           default("")
#  closed_flag     :boolean          default(FALSE)
#  closing_time    :time
#  description     :text             default("")
#  force_closed    :boolean          default(FALSE)
#  name            :string           not null
#  opening_time    :time
#  prefecture_code :integer
#  site_area       :string           default("")
#  usage_fee       :string           default("")
#  web_site        :string           default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  facebook_id     :string           default("")
#  instagram_id    :string           default("")
#  twitter_id      :string           default("")
#
