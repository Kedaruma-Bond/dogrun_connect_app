FactoryBot.define do
  factory :dog do
    name { Faker::Creature::Dog.name }
    breed { Faker::Creature::Dog.breed }
    birthday { Faker::Date.birthday(min_age: 0, max_age: 16) }
    weight { Faker::Number.between(from: 1, to: 50) }
    owner_comment { Faker::Lorem.paragraphs(number: 2) }
    association :user

    trait :castrated do
      castration { 'castrated' }
    end

    trait :non_castrated do
      castration { 'non_castrated' }
    end

    trait :public_view do
      public { 'public_view' }
    end

    trait :non_public do
      public { 'non_public' }
    end

    trait :male do
      sex { 0 }
    end

    trait :female do
      sex { 1 }
    end
  end
end

# == Schema Information
#
# Table name: dogs
#
#  id              :bigint           not null, primary key
#  birthday        :date
#  breed           :string           default("")
#  castration      :boolean          not null
#  name            :string           not null
#  owner_comment   :text             default("")
#  public          :boolean          not null
#  sex             :integer
#  thumbnail_photo :string
#  weight          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_dogs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
