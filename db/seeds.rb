User.create!(name: 'へのへの もへじ',
            email: 'henoheno@moheji.com',
            password: 'foobar',
            password_confirmation: 'foobar')

10.times do |n|
  name = Faker::Name.name
  email = "test-#{n}@exmple.com"
  password = 'password'
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)
end

# user = User.first
# castration = 'castrated'
# public = 'public_view'
# 2.times do
#   user.dogs.create!(
#     name: Faker::Creature::Dog.name,
#     castration: castration,
#     public: public,
#     breed: Faker::Creature::Dog.breed,
#     sex: Faker::Number.between(from: 0, to: 1),
#     weight: Faker::Number.between(from: 1, to: 40),
#     owner_comment: Faker::Lorem.sentences(number: 1)
#   )
# end

users = User.order(:created_at).first(6)
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
    owner_comment: Faker::Lorem.sentences(number: 1)
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
    owner_comment: Faker::Lorem.sentences(number: 1)
  )
end

dogs = Dog.all
dogrun_place = 0
dogs.each do |dog|
  registration_number = Faker::Number.between(from: 1, to: 2000)
  dog.registration_numbers.create!(dogrun_place: dogrun_place, registration_number: registration_number)
end
dogrun_place = 1
dogs.each do |dog|
  registration_number = Faker::Number.between(from: 1, to: 2000)
  dog.registration_numbers.create!(dogrun_place: dogrun_place, registration_number: registration_number)
end

registration_numbers = RegistrationNumber.all
3.times do |t|
  entry_at = Time.zone.now - "#{t}" # rubocop:disable Style/RedundantInterpolation
  exit_at = Time.zone.now
  registration_numbers.each { |registration_number| registration_number.entries.create!(entry_at: entry_at, exit_at: exit_at, dog_id: registration_number.dog_id) }
end
