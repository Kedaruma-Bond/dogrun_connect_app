FactoryBot.define do
  factory :dog do
    option { "MyString" }
    name { "MyString" }
    castration { false }
    public { false }
    breed { "MyString" }
    sex { false }
    birthday { "2022-06-09" }
    weight { 1 }
    owner_comment { "MyText" }
  end
end
