User.create!(name: 'へのへの もへじ',
            email: 'henoheno@moheji.com',
            password: 'foobar',
            password_confirmation: 'foobar')

10.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@test.com"
  password = 'password'
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)
end

users = User.order(:created_at).take(6)
castration = 'castrated'
public = 'public_view'
users.each { |user| user.dogs.create!(name: Faker::Creature::Dog.name, castration: castration, public: public) }

users = User.order(:created_at).take(5)
castration = 'non_castrated'
public = 'non_public'
users.each { |user| user.dogs.create!(name: Faker::Creature::Dog.name, castration: castration, public: public) }

n = Dog.count
dogs = Dog.all
n.times do
  dogrun_place = 0
  registration_number = Faker::Number.between(from: 1, to: 2000)
  dogs.each { |dog| dog.registration_numbers.create!(dogrun_place: dogrun_place, registration_number: registration_number) }
end
