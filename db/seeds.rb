# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(
  name: 'test',
  email: Faker::Internet.email,
  password: 'password',
  password_confirmation: 'password'
)

10.times do
  User.create!(
    name: Faker::Name.unique.first_name,
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password'
  )
end

20.times do
  Post.create!(
    user: User.offset(rand(User.count)).first,
    content: Faker::Lorem.sentence
  )
end
