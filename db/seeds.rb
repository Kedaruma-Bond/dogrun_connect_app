# dogrun_place id: 1 for grand admin
grand_admin = DogrunPlace.create!(name: 'grand_admin')
# dogrun_place id: 2 犬のしつけ広場
dogrun_place_2 = DogrunPlace.create!(name: '犬のしつけ広場')
# dogrun_place id: 3 Dog with
dogrun_place_3 = DogrunPlace.create!(name: 'Dog with')

# grand admin create
User.create!(name: 'grand_admin',
            email: 'grand_admin@erai.com',
            password: 'foobuz',
            password_confirmation: 'foobuz',
            role: 1,
            dogrun_place: grand_admin
            )

# inu_shitsuke_hiroba admin create
User.create!(name: '犬のしつけ広場_admin',
            email: 'admin2@erai.com',
            password: 'foobuz',
            password_confirmation: 'foobuz',
            role: 1,
            dogrun_place: dogrun_place_2
            )

# Dor_with admin create
User.create!(name: 'Dog with_admin',
            email: 'admin3@erai.com',
            password: 'foobuz',
            password_confirmation: 'foobuz',
            role: 1,
            dogrun_place: dogrun_place_3
            )            

# デフォルトユーザー作成
User.create!(name: 'へのへの もへじ',
            email: 'henoheno@moheji.com',
            password: 'foobar',
            password_confirmation: 'foobar')

10.times do |n|
  name = Faker::Name.name
  email = "test-#{n}@example.com"
  password = 'password'
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)
end

users = User.order(:created_at).limit(9).offset(3)
castration = 'castrated'
public = 'public_view'
users.each do |u|
  u.dogs.create!(
    name: Faker::Creature::Dog.name,
    castration: castration,
    public: public,
    breed: Faker::Creature::Dog.breed,
    sex: Faker::Number.between(from: 0, to: 1),
    weight: Faker::Number.between(from: 1, to: 40),
    owner_comment: Faker::Lorem.paragraph(sentence_count: 5),
    thumbnail_photo: nil
  )
end

users = User.order(:created_at).last(5)
castration = 'non_castrated'
public = 'non_public'
users.each do |u|
  u.dogs.create!(
    name: Faker::Creature::Dog.name,
    castration: castration,
    public: public,
    breed: Faker::Creature::Dog.breed,
    sex: Faker::Number.between(from: 0, to: 1),
    weight: Faker::Number.between(from: 1, to: 40),
    owner_comment: Faker::Lorem.paragraph(sentence_count: 5)
  )
end

dogs = Dog.all
dogs.each do |dog|
  registration_number = Faker::Number.between(from: 1, to: 2000)
  dog.registration_numbers.create!(registration_number: registration_number, dogrun_place: dogrun_place_2)
end
dogs.each do |dog|
  registration_number = Faker::Number.between(from: 1, to: 2000)
  dog.registration_numbers.create!(registration_number: registration_number, dogrun_place: dogrun_place_3)
end

registration_numbers = RegistrationNumber.all

registration_numbers.each do |registration_number| 
  entry_at_1 = Time.zone.now - 1.days
  exit_at_1 = Time.zone.now - 1.days + 1_800
  entry_at_2 = Time.zone.now - 7.days
  exit_at_2 = Time.zone.now - 7.days + 1_800
  entry_at_3 = Time.zone.now - 30.days
  exit_at_3 = Time.zone.now - 30.days + 1_800
  registration_number.entries.create!(entry_at: entry_at_1, exit_at: exit_at_1, dog_id: registration_number.dog_id)
  registration_number.entries.create!(entry_at: entry_at_2, exit_at: exit_at_2, dog_id: registration_number.dog_id)
  registration_number.entries.create!(entry_at: entry_at_3, exit_at: exit_at_3, dog_id: registration_number.dog_id)
end
