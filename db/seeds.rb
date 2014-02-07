# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

1.upto 20 do
  n1 = Random.rand(5..10)
  n2 = Random.rand(8..14)
  title = Faker::Lorem.words(n1).join(' ')
  body = Faker::Lorem.paragraphs(n2).collect{|parag| "<p>#{parag}</p>" }.join('')
  Post.create title: title, body: body
end