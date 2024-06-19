# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
addresses = [
  "Avenida Atlântica, 1702 - Copacabana",
  "Rua Barata Ribeiro, 216 - Copacabana",
  "Rua Nossa Senhora de Copacabana, 552 - Copacabana",
  "Rua Figueiredo de Magalhães, 298 - Copacabana",
  "Rua Miguel Lemos, 31 - Copacabana",
  "Rua Bolívar, 40 - Copacabana",
  "Rua Duvivier, 45 - Copacabana",
  "Rua Barão de Ipanema, 50 - Copacabana",
  "Rua Xavier da Silveira, 25 - Copacabana",
  "Avenida Vieira Souto, 206 - Ipanema",
  "Rua Visconde de Pirajá, 444 - Ipanema",
  "Rua Prudente de Morais, 450 - Ipanema",
  "Rua Farme de Amoedo, 80 - Ipanema",
  "Rua Joana Angélica, 37 - Ipanema",
  "Rua Aníbal de Mendonça, 87 - Ipanema",
  "Rua Garcia d'Ávila, 141 - Ipanema",
  "Rua Redentor, 145 - Ipanema",
  "Avenida Delfim Moreira, 630 - Leblon",
  "Rua Ataulfo de Paiva, 255 - Leblon",
  "Rua Dias Ferreira, 190 - Leblon",
  "Rua General San Martin, 122 - Leblon",
  "Rua Humberto de Campos, 315 - Leblon",
  "Rua Aristides Espínola, 53 - Leblon",
  "Rua Bartolomeu Mitre, 570 - Leblon",
  "Rua Rainha Guilhermina, 320 - Leblon",
  "Rua General Artigas, 307 - Leblon",
  "Praia de Botafogo, 340 - Botafogo, Rio de Janeiro",
  "Rua São Clemente, 230 - Botafogo, Rio de Janeiro",
  "Rua Voluntários da Pátria, 150 - Botafogo, Rio de Janeiro",
  "Rua Mena Barreto, 24 - Botafogo, Rio de Janeiro",
  "Rua Sorocaba, 77 - Botafogo, Rio de Janeiro",
  "Rua da Passagem, 98 - Botafogo, Rio de Janeiro",
  "Rua General Polidoro, 190 - Botafogo, Rio de Janeiro",
  "Rua Bambina, 72 - Botafogo, Rio de Janeiro",
  "Rua Lauro Muller, 116 - Botafogo, Rio de Janeiro",
  "Rua Marques de Abrantes, 160 - Flamengo",
  "Rua Paissandu, 72 - Flamengo",
  "Rua Marquês de Pinedo, 15 - Flamengo",
  "Rua Senador Vergueiro, 218 - Flamengo",
  "Rua Buarque de Macedo, 61 - Flamengo",
  "Rua Corrêa Dutra, 99 - Flamengo",
  "Rua Barão do Flamengo, 32 - Flamengo",
  "Rua Dois de Dezembro, 38 - Flamengo",
  "Avenida Rui Barbosa, 170 - Flamengo",
  "Rua Almirante Tamandaré, 225 - Flamengo",
  "Rua São Salvador, 75 - Laranjeiras",
  "Rua Ipiranga, 65 - Laranjeiras",
  "Rua das Laranjeiras, 314 - Laranjeiras",
  "Rua General Glicério, 50 - Laranjeiras",
  "Rua Conde de Baependi, 30 - Laranjeiras"
]

interests = [
  {
    community: "Sport",
    subcommunities: ["Soccer", "Surf", "Bowling", "Basketball", "Tennis"]
  },
  {
    community: "Music",
    subcommunities: ["Rock", "Jazz", "Classical", "Hip-hop", "Electronic"]
  },
  {
    community: "Arts",
    subcommunities: ["Painting", "Sculpture", "Photography", "Drawing", "Dance"]
  },
  {
    community: "Leisure",
    subcommunities: ["Travel", "Gaming", "Reading", "Cooking", "Gardening"]
  }
]

puts 'Cleaning user database...'
User.destroy_all
puts "Done!"

puts 'Cleaning community database...'
Community.destroy_all
puts "Done!"

n_users = addresses.count
puts "Generating #{n_users} users..."

i = 0
n_users.times do
  user = User.new(
    name: Faker::Name.first_name,
    email: Faker::Internet.email,
    username: Faker::Internet.username,
    password: 123_456,
    address: addresses[i],
    description: Faker::Lorem.paragraph_by_chars
  )

  file = File.new("app/assets/images/seed_pictures/photo_#{i + 1}.jpg", "r")
  user.photo.attach(io: file, filename: "photo_#{i + 1}.jpg", content_type: "image/jpg")

  puts "Seeding #{user.name}, username: #{user.username}"
  user.save!
  i += 1
end
puts "Done!"

puts "First User e-mail: #{User.first.email}"

puts 'Generating communities...'
interests.each do |hash|
  community = Community.new name: hash[:community]
  puts "Community #{community.name} generated"
  community.save!
  hash[:subcommunities].each do |subcommunity|
    sub = Subcommunity.new name: subcommunity, community: community
    puts "Subcommunity #{subcommunity} generated in Community #{community.name}"
    sub.save!
    groupchat = Groupchat.new(name: subcommunity, groupchatable: sub)
    groupchat.save!
  end
end
puts "Done!"

puts "Generating randomized interests..."
User.all.each do |user|
  n = (1..5).to_a.sample
  sub_array = Subcommunity.all.sample(n)
  sub_array.each do |subcommunity|
    interest = Interest.new user: user, interestable: subcommunity
    puts "Seeding interest in #{subcommunity.name} for user #{user.username}"
    interest.save!
  end
end

puts "Creating master user, Shia LaBeouf"
master = User.new(
  name: "Shia LaBeouf",
  email: "la_buff@shia.com",
  username: 'shia.laBUFF',
  password: 123_456,
  address: "Avenida Delfim Moreira 558, Leblon, Rio de Janeiro - Rio de Janeiro, 22441, Brasil",
  description: "I'm DOING it!!"
)

file = File.new("app/assets/images/seed_pictures/master_user.jpg", "r")
master.photo.attach(io: file, filename: "master_user.jpg", content_type: "image/jpg")
master.save!

subcommunity = Subcommunity.find_by(name: "Rock")
interest = Interest.new user: master, interestable: subcommunity
puts "Seeding interest in #{subcommunity.name} for master user"
interest.save!
puts "Done!"

puts "Master User e-mail: #{master.email}"
