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
  "Rua Farme de Amoedo, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Avenida Atlântica, Copacabana, Rio de Janeiro - Rio de Janeiro, 22010, Brasil",
  "Rua Visconde de Pirajá, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Barata Ribeiro, Copacabana, Rio de Janeiro - Rio de Janeiro, 22040, Brasil",
  "Rua Maria Quitéria, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Avenida Vieira Souto, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Nossa Senhora de Copacabana, Copacabana, Rio de Janeiro - Rio de Janeiro, 22020, Brasil",
  "Rua Prudente de Morais, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Constante Ramos, Copacabana, Rio de Janeiro - Rio de Janeiro, 22051, Brasil",
  "Rua Henrique Dumont, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Figueiredo Magalhães, Copacabana, Rio de Janeiro - Rio de Janeiro, 22031, Brasil",
  "Rua Vinícius de Moraes, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Siqueira Campos, Copacabana, Rio de Janeiro - Rio de Janeiro, 22031, Brasil",
  "Rua Joana Angélica, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua República do Peru, Copacabana, Rio de Janeiro - Rio de Janeiro, 22021, Brasil",
  "Rua Aníbal de Mendonça, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Xavier da Silveira, Copacabana, Rio de Janeiro - Rio de Janeiro, 22061, Brasil",
  "Rua Garcia d'Ávila, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Bolívar, Copacabana, Rio de Janeiro - Rio de Janeiro, 22061, Brasil",
  "Rua Redentor, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Sá Ferreira, Copacabana, Rio de Janeiro - Rio de Janeiro, 22071, Brasil",
  "Rua Nascimento Silva, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Miguel Lemos, Copacabana, Rio de Janeiro - Rio de Janeiro, 22071, Brasil",
  "Rua Alberto de Campos, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Souza Lima, Copacabana, Rio de Janeiro - Rio de Janeiro, 22081, Brasil",
  "Rua Jangadeiros, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Pompeu Loureiro, Copacabana, Rio de Janeiro - Rio de Janeiro, 22061, Brasil",
  "Rua Alberto de Campos, Ipanema, Rio de Janeiro - Rio de Janeiro, 22411, Brasil",
  "Rua Djalma Ulrich, Copacabana, Rio de Janeiro - Rio de Janeiro, 22071, Brasil",
  "Rua Barao da Torre, Ipanema, Rio de Janeiro - Rio de Janeiro, 22411, Brasil",
  "Rua Francisco Otaviano, Copacabana, Rio de Janeiro - Rio de Janeiro, 22080, Brasil",
  "Rua Teixeira de Melo, Ipanema, Rio de Janeiro - Rio de Janeiro, 22410, Brasil",
  "Rua Miguel Lemos, Copacabana, Rio de Janeiro - Rio de Janeiro, 22071, Brasil",
  "Rua Joana Angélica, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Almirante Gonçalves, Copacabana, Rio de Janeiro - Rio de Janeiro, 22071, Brasil",
  "Rua Farme de Amoedo, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Santa Clara, Copacabana, Rio de Janeiro - Rio de Janeiro, 22041, Brasil",
  "Rua Vinícius de Moraes, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Dias da Rocha, Copacabana, Rio de Janeiro - Rio de Janeiro, 22051, Brasil",
  "Rua Visconde de Pirajá, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Barata Ribeiro, Copacabana, Rio de Janeiro - Rio de Janeiro, 22051, Brasil",
  "Rua Maria Quitéria, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Bolívar, Copacabana, Rio de Janeiro - Rio de Janeiro, 22061, Brasil",
  "Rua Prudente de Morais, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Henrique Dumont, Ipanema, Rio de Janeiro - Rio de Janeiro, 22420, Brasil",
  "Rua Xavier da Silveira, Copacabana, Rio de Janeiro - Rio de Janeiro, 22061, Brasil",
  "Rua Figueiredo Magalhães, Copacabana, Rio de Janeiro - Rio de Janeiro, 22031, Brasil"
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

puts 'Cleaning user database'

User.destroy_all

puts 'Cleaning community database'

Community.destroy_all

n_users = addresses.count
puts "Generating #{n_users} users"

i = 0

n_users.times do
  user = User.new(
    name: Faker::Name.first_name,
    email: Faker::Internet.email,
    username: Faker::Internet.username,
    password: 123_456,
    address: addresses[i]
  )

  user.save!
  i += 1
end

puts 'Users generated'

puts 'Generating communities'

interests.each do |hash|
  community = Community.new name: hash[:community]
  community.save!
  hash[:subcommunities].each do |subcommunity|
    sub = Subcommunity.new name: subcommunity, community: community
    sub.save!
  end
end

puts 'Generated communities'

User.all.each do |user|
  n = (1..5).to_a.sample
  sub_array = Subcommunity.all.sample(n)
  sub_array.each do |subcommunity|
    interest = Interest.new user: user, interestable: subcommunity
    interest.save!
  end
end
