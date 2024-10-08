puts "creating new artists..."

# artists = [{
#   name: 'Olivia Rodrigo',
#   banner_url: "https://www.dexerto.com/cdn-cgi/image/width=1920,quality=75,format=auto/https://editors.dexerto.com/wp-content/uploads/2023/06/27/fans-upset-olivia-rodrigo-guts-album-cover-1.jpg",
#   photo_url: "https://evenko.ca/_uploads/event/57045/splash.jpg?v=1694617788"},
#   {name: 'Machine Head',
#   banner_url: "https://www.worshipmetal.com/wp-content/uploads/2017/11/Machine-Head-banner.jpg",
#   photo_url: "https://evenko.ca/en/events/58004/machine-head/mtelus/02-06-2024"},
#   {name: 'Jacob Collier',
#   banner_url: "https://repo.thewildcity.com/3017-jacob-collier-banner.jpg",
#   photo_url: "https://media.npr.org/assets/img/2016/07/11/jacob-collier2-18a5864435ce79a0416b9095b82d34f70f2dcdb4.jpg"},
#   {name: 'Half Moon Run',
#   banner_url: "https://thecbpshop.com/cdn/shop/files/HMR_BannerV0-06_a1c13a20-13f2-4839-9817-86e84bbfddf2_1600x.png?v=1677267615",
#   photo_url: "https://s1.ticketm.net/dam/a/1d5/7c868895-42e3-4230-b86d-97d82ec971d5_EVENT_DETAIL_PAGE_16_9.jpg"},
#   {name: 'Excision',
#   banner_url: "https://i.imgur.com/DUD3H8jg.jpg",
#   photo_url: "https://www.evenko.ca/_uploads/event/56884/splash.jpg?v=1693579940"}]


shows = [
  {
    artist: 'Olivia Rodrigo',
    city: 'Montreal',
    venue: 'Centre Bell',
    date: 'Tue, 26 March 2024 00:00:00.000000000 UTC +00:00'
  },
  {
    artist: 'Machine Head',
    city: 'Montreal',
    venue: 'MTELUS',
    date: 'Tue, 6 February 2024 00:00:00.000000000 UTC +00:00'
  },
  {
    artist: 'Jacob Collier',
    city: 'Montreal',
    venue: 'Place Bell',
    date: 'Tue, 23 April 2024 00:00:00.000000000 UTC +00:00'
  },
  {
    artist: 'Half Moon Run',
    city: 'Montreal',
    venue: 'Montreal Olympic Park',
    date: 'Thu, 30 May 2024 00:00:00.000000000 UTC +00:00'
  },
  {
    artist: 'Excision',
    city: 'Laval',
    venue: 'Place Bell',
    date: 'Sat, 16 March 2024 00:00:00.000000000 UTC +00:00'
  },
  {
    artist: 'Tim McGraw',
    city: 'Montreal',
    venue: 'Centre Bell',
    date: 'Thu, 2 May 2024 00:00:00.000000000 UTC +00:00'
  },
  {
    artist: 'Armin Van Buuren',
    city: 'Montreal',
    venue: 'Jacques-Cartier Pier',
    date: 'Sat, 27 January 2024 00:00:00.000000000 UTC +00:00'
  },
  {
    artist: 'Queens of the Stone Age',
    city: 'Montreal',
    venue: 'Place Bell',
    date: 'Sat, 13 April 2024 00:00:00.000000000 UTC +00:00'
  },
  {
    artist: 'Sarah McLachlan',
    city: 'Montreal',
    venue: 'Place Bell',
    date: 'Thu, 20 June 2024 00:00:00.000000000 UTC +00:00'
  }
]

# artists.each do |band|
#   sleep(3)
#   puts "Creating the artist #{band[:name]}"
#   artist = Artist.create(name: "#{band[:name]}")
#   photo = URI.open(band[:photo_url])
#   artist.photo.attach(io: photo, filename: "band_photo.png", content_type: "image/png")
#   puts "Creating concerts for #{band[:name]}"

  shows.each do |show|
    # if show[:artist] == band
      puts "creating #{show[:artist]} concert..."
      concert = Concert.new(
        artist_id: Artist.find_by(name: show[:artist]).id,
        city: show[:city],
        venue: show[:venue],
        date: show[:date]
      )
      concert.save!
      puts "Created new concert with id #{concert.id} for #{show[:artist]}"
    # end
  end
# end
