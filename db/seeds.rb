require "open-uri"
require "json"
require "rest-client"
require_relative "users"

puts "Cleaning the comments table"
Comment.destroy_all
puts "Cleaning the reviews table"
Review.destroy_all
puts "Cleaning the attendances table"
Attendance.destroy_all
puts "Cleaning the concerts table"
Concert.destroy_all
puts "Cleaning the artist table"
Artist.destroy_all
puts "Cleaning the users table."
User.destroy_all


bands = [{ name: 'The Menzingers', id: '181106',
           banner_url: "https://thefader-res.cloudinary.com/private_images/c_limit,w_1024/c_crop,h_418,w_803,x_83,y_171,f_auto,q_auto:eco/TheMenzingers_JessFlynn_-065_Web_xvx0zq/TheMenzingers_JessFlynn_-065_Web_xvx0zq.jpg",
           photo_url:"https://riotfest.org/wp-content/uploads/2019/10/2019-MENZOS-QA_WEB.jpg" },
         { name: 'The Gaslight Anthem', id: '16502',
           banner_url: "https://www.punkrocktheory.com/sites/default/files/styles/image_style_huge_horizontal_rectangle/public/thegaslightanthem_0.jpg?itok=LwA_CX8y",
           photo_url:"https://townsquare.media/site/838/files/2015/12/gaslightanthem1.jpg" },
         { name: 'Muse', id: '143',
           banner_url: "https://variety.com/wp-content/uploads/2022/08/Muse_2022_01_1636-F-1-e1661547894920.jpeg",
           photo_url:"https://pechangaarenasd.com/wp-content/uploads/PA-Muse-750x400-3.jpg" },
         { name: 'Burna Boy', id: '1844148',
           banner_url: "https://guardian.ng/wp-content/uploads/2018/12/Burna-Boy_AllAfrica.png",
           photo_url:"https://cdn.vanguardngr.com/wp-content/uploads/2023/06/burna-boy-1024x683.jpeg" },
         { name: 'Polo & Pan', id: '8796810',
           banner_url: "https://www.billboard.com/wp-content/uploads/media/Polo-and-Pan-2019-cr-Olivier-Ortion-billboard-1548.jpg",
           photo_url:"https://i.ytimg.com/vi/ootQs7sVulY/maxresdefault.jpg" },
         { name: 'Louise Attaque', id: '45021',
           banner_url: "https://s3.ca-central-1.amazonaws.com/files.quartierdesspectacles.com/import/vitrine/activity/34805/34805.jpg",
           photo_url:"https://cdn-s-www.lalsace.fr/images/7B5FD0F7-B22B-4A64-9896-9B8771A6D540/NW_raw/le-groupe-louise-attaque-lors-d-une-emission-televisee-photo-sipa-1673352621.jpg" },
         { name: 'Gojira', id: '2761',
           banner_url: "https://imageio.forbes.com/specials-images/imageserve/605d3e80fe13e1da9e35fb08/Gojira-band-members-left-to-right--Christian-Andreu--Joe-Duplantier--Mario/0x0.jpg?format=jpg&crop=4717,3146,x0,y920,safe&width=960",
           photo_url:"https://media.hardwiredmagazine.com/2017/08/gojira-band-promo-2017-logo.jpg" },
         { name: 'Tool', id: '26633',
           banner_url: "https://media.pitchfork.com/photos/6151d4465f20b295d9d2c2a0/2:1/w_2560%2Cc_limit/Tool.jpg",
           photo_url:"https://www.xcelenergycenter.com/assets/img/Tool_WEB_588x370-260f0f9f52.jpg" }]

bands.each do |band|
  sleep(3)
  puts "Creating the artist #{band[:name]}"
  artist = Artist.create(name: "#{band[:name]}")
  photo = URI.open(band[:photo_url])
  artist.photo.attach(io: photo, filename: "band_photo.png", content_type: "image/png")
  puts "Creating upcoming concerts for #{band[:name]}"

  upcoming_url = "https://rest.bandsintown.com/artists/id_#{band[:id]}/events?app_id=#{ENV['BANDS_IN_TOWN_API_KEY']}"

  upcoming_response = RestClient.get(upcoming_url)
  upcoming_shows = JSON.parse(upcoming_response)

  upcoming_shows.first(12).each do |show|
    concert = Concert.new
    concert.city = show["venue"]["location"]
    concert.venue = show["venue"]["name"]
    concert.date = show["starts_at"]
    concert.artist_id = artist.id
    concert.save!
    puts "Created upcoming concert with id #{concert.id} for #{band[:name]}"
  end

  past_url = "https://rest.bandsintown.com/artists/id_#{band[:id]}/events?app_id=#{ENV['BANDS_IN_TOWN_API_KEY']}&date=2023-01-01,2023-12-31"
  past_response = RestClient.get(past_url)
  past_shows = JSON.parse(past_response)

  "Creating past concerts..."

  past_shows.first(12).each do |show|
    concert = Concert.new
    concert.city = show["venue"]["city"]
    concert.venue = show["venue"]["name"]
    concert.date = show["datetime"]
    concert.artist_id = artist.id
    concert.save!
    puts "Created past concert with id #{concert.id} for #{band[:name]}"
  end
end

puts "creating users seeds Bowie, Paloma and us!"

default_avatar_url = "https://hips.hearstapps.com/hmg-prod/images/sigourney-weaver-avatar-ii-the-way-of-water-1670323174.jpg?crop=0.500xw:0.949xh;0.299xw,0.0514xh&resize=1200:*"
default_banner_url = "https://townsquare.media/site/62/files/2021/11/attachment-brian-ruiz.jpg?w=980&q=75"
default_password = "123456"
default_city = "Montreal"


USERS.each do |user_hash|
  new_user = User.new(
    username: user_hash[:username],
    age: user_hash[:age],
    bio: user_hash[:bio],
    email: user_hash[:email]
  )

  avatar = URI.open(user_hash[:avatar_url] || default_avatar_url)
  new_user.avatar.attach(io: avatar, filename: "avatar.png", content_type: "image/png")
  banner = URI.open(user_hash[:banner_url] || default_banner_url)
  new_user.banner.attach(io: banner, filename: "banner.png", content_type: "image/png")

  new_user.city = default_city unless user_hash[:city]
  new_user.password = default_password unless user_hash[:password]
  new_user.save!
end

puts "Done!!!"

puts "creating seed bowie attendance"
bowies_concert = Concert.find_by(venue: "Le Studio TD")
bowie = User.find_by(username: "Bowie")
Attendance.create!(user: bowie, concert: bowies_concert)
puts "done!"

puts "creating seed cat attendance"
cats_concert = Concert.find_by(venue: "Le Studio TD")
cat = User.find_by(username: "Cat")
Attendance.create!(user: cat, concert: cats_concert)
puts "done!"

puts "creating seed antoine attendance"
antoines_concert = Concert.find_by(venue: "Le Studio TD")
antoine = User.find_by(username: "Antoine")
Attendance.create!(user: antoine, concert: antoines_concert)
puts "done!"

puts "creating seed sofia attendance"
sofias_concert = Concert.find_by(venue: "Le Studio TD")
sofia = User.find_by(username: "Sofia")
Attendance.create!(user: sofia, concert: sofias_concert)
puts "done!"

puts "creating seed doga attendance"
dogas_concert = Concert.find_by(venue: "Le Studio TD")
doga = User.find_by(username: "Doga")
Attendance.create!(user: doga, concert: dogas_concert)
puts "done!"


puts "seed writing cats review"
cats_review = Review.new(
  rating: 4,
  content: "Honestly, I had an awesome time but I feel like the sound was lacking just a little bit of vocals. Otherwise
  , incredible performance and experience!",
  attendance: Attendance.find_by(user: cat)
)
cats_review.photos.attach(io: URI.open("https://destination-ontario-prod.s3.ca-central-1.amazonaws.com/files/s3fs-public/styles/article_masthead/public/2021-10/great-outdoo-venues-live-music-lovers.jpg?VersionId=Zr8J.0RRlDKcNYF6Vz1hOVy.YsH7J1aT&h=7da987e6&itok=2bB9Km5t"),
filename: "conert_photo_1", content_type: "image/png")
cats_review.photos.attach(io: URI.open("https://en.parisinfo.com/var/otcp/sites/images/node_43/node_51/node_77884/node_77888/yoyo-palais-de-tokyo-concert-et-lasers-bleus-%7C-630x405-%7C-%C2%A9-cedric-canezza/11967098-1-fre-FR/Yoyo-Palais-de-Tokyo-Concert-et-lasers-bleus-%7C-630x405-%7C-%C2%A9-Cedric-Canezza.jpg"),
filename: "conert_photo_2", content_type: "image/png")
cats_review.photos.attach(io: URI.open("https://turntable.kagiso.io/images/iStock-1181169462.width-800.jpg"),
filename: "conert_photo_3", content_type: "image/png")

cats_review.save!
puts "done!"

puts "seed writing bowies review"
bowies_review = Review.new(
  rating: 5,
  content: "What an incredible show! I'm blown away. If you get the chance, this is a MUST SEE",
  attendance: Attendance.find_by(user: bowie)
)
# bowies_review.photos.attach(io: URI.open("https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Muse_in_Sydney.jpg/800px-Muse_in_Sydney.jpg"),
#                             filename: "conert_photo_1", content_type: "image/png")
# bowies_review.photos.attach(io: URI.open("https://en.parisinfo.com/var/otcp/sites/images/node_43/node_51/node_77884/node_77888/yoyo-palais-de-tokyo-concert-et-lasers-bleus-%7C-630x405-%7C-%C2%A9-cedric-canezza/11967098-1-fre-FR/Yoyo-Palais-de-Tokyo-Concert-et-lasers-bleus-%7C-630x405-%7C-%C2%A9-Cedric-Canezza.jpg"),
#                             filename: "conert_photo_2", content_type: "image/png")
# bowies_review.photos.attach(io: URI.open("https://turntable.kagiso.io/images/iStock-1181169462.width-800.jpg"),
#                             filename: "conert_photo_3", content_type: "image/png")

bowies_review.save!
puts "done!"

puts "seed writing antoines review"
antoines_review = Review.new(
  rating: 5,
  content: "Amazeballs!!!!!!",
  attendance: Attendance.find_by(user: antoine)
)
antoines_review.photos.attach(io: URI.open("https://images.dailyhive.com/20161006093650/Tegan-Sara-Brandon-Artis-Photography-12.jpg"),
                          filename: "conert_photo_1", content_type: "image/png")
antoines_review.photos.attach(io: URI.open("https://www.livingstonmusic.co.uk/wp-content/uploads/2020/11/wp2097452.jpg"),
                          filename: "conert_photo_2", content_type: "image/png")
antoines_review.photos.attach(io: URI.open("https://the-peak.ca/wp-content/uploads/2018/05/Cell-phones-at-concerts.jpg"),
                          filename: "conert_photo_3", content_type: "image/png")

antoines_review.save!
puts "done!"

puts "seed writing sofias review"
sofias_review = Review.new(
  rating: 3,
  content: "I think I like Nickelback better",
  attendance: Attendance.find_by(user: sofia)
)
sofias_review.photos.attach(io: URI.open("https://i0.wp.com/www.photoshelter.com/img-get/I0000niEPHJNXXGY/s/1000/tegan-and-sara-7549.jpg?w=1170"),
                          filename: "conert_photo_1", content_type: "image/png")
sofias_review.photos.attach(io: URI.open("https://media.istockphoto.com/id/1247853982/photo/cheering-crowd-with-hands-in-air-at-music-festival.jpg?s=170667a&w=0&k=20&c=3jiqrNPSnaHiVGevyMIK0m_3V3VnZXYefKbjxyl1anM="),
                          filename: "conert_photo_2", content_type: "image/png")
sofias_review.photos.attach(io: URI.open("https://live.staticflickr.com/4686/25288641378_1af95c1243_b.jpg"),
                          filename: "conert_photo_3", content_type: "image/png")
sofias_review.save!
puts "done!"

puts "seed writing doga review"
doga_review = Review.new(
  rating: 5,
  content: "You just had to be there",
  attendance: Attendance.find_by(user: doga)
)
doga_review.photos.attach(io: URI.open("https://pbs.twimg.com/media/CZb6EDiWkAAW-w2?format=jpg&name=large"),
                          filename: "conert_photo_1", content_type: "image/png")
doga_review.photos.attach(io: URI.open("https://en.parisinfo.com/var/otcp/sites/images/node_43/node_51/node_77884/node_77888/yoyo-palais-de-tokyo-concert-et-lasers-bleus-%7C-630x405-%7C-%C2%A9-cedric-canezza/11967098-1-fre-FR/Yoyo-Palais-de-Tokyo-Concert-et-lasers-bleus-%7C-630x405-%7C-%C2%A9-Cedric-Canezza.jpg"),
                          filename: "conert_photo_2", content_type: "image/png")
doga_review.photos.attach(io: URI.open("https://turntable.kagiso.io/images/iStock-1181169462.width-800.jpg"),
                          filename: "conert_photo_3", content_type: "image/png")

doga_review.save!
puts "done!"

puts "seed commenting on review"
Comment.create!(content: "I agree!!!! We are lucky we got to see that!", user: User.last, review: Review.first)
puts "all done!"
