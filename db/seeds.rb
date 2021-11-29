# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = User.create([
  { email: "admin@lib.com", password: "admin123", first_name: "Admin", last_name: "User", admin: true },
  { email: "student@lib.com", password: "student123", first_name: "Student", last_name: "User", admin: false }
])

students = Student.create([
  { lrn: "888888", firstname: "Tony", lastname: "Stark", contact_number: "0912351234" },
  { lrn: "121221", firstname: "Steve", lastname: "Rogers", contact_number: "0912351234" }
])

puts "Users seeded!"
