# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

 # Create Users
 5.times do
  User.create!(
    email:    Faker::Internet.email,
    password: Faker::Internet.password
  )
end
users = User.all

# Creat Wikis
20.times do
  Wiki.create!(
    title:    Faker::Lorem.characters(5..50),
    body:     Faker::Markdown.sandwich(5),
    private:  Faker::Boolean.boolean,
    user:     users.sample

  )
end
wikis = Wiki.all

puts "Seed finished"
puts "#{User.count} users created."
puts "#{Wiki.count} wikis created."
