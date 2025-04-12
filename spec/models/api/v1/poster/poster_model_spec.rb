require "rails_helper"
require 'simplecov'
SimpleCov.start

RSpec.describe "Posters queries", type: :model do
  it 'returns posters in descending order by created_at time' do
    poster_count = Poster.all.count
    expect(poster_count).to eq(0)
    Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
    Poster.create(name: "FAILURE", description: "Why bother trying? It's probably not worth it.", price: 68.00, year: 2019, vintage: true, img_url: "https://t3.ftcdn.net/jpg/11/70/36/90/240_F_1170369060_uUGb9y0Crkbn6hIHwRtWcCdpMfSDBaqv.jpg")
    Poster.create(name: "MEDIOCRITY",description: "Dreams are just that—dreams.",price: 75.00,year: 2021,vintage: false,img_url: "https://t3.ftcdn.net/jpg/10/94/43/46/240_F_1094434660_eWqgET75FkLFBMKBz7kd5E3dYIM7tgpO.jpg")
    Poster.create(name: "MEDIOCRITY",description: "Dreams are just that—dreams.",price: 75.00,year: 2021,vintage: false,img_url: "https://t3.ftcdn.net/jpg/10/94/43/46/240_F_1094434660_eWqgET75FkLFBMKBz7kd5E3dYIM7tgpO.jpg")
    Poster.create(name: "MEDIOCRITY",description: "Dreams are just that—dreams.",price: 75.00,year: 2021,vintage: false,img_url: "https://t3.ftcdn.net/jpg/10/94/43/46/240_F_1094434660_eWqgET75FkLFBMKBz7kd5E3dYIM7tgpO.jpg")

    id_first_made = Poster.first.id
    id_second_made = Poster.second.id
    id_third_made = Poster.third.id
    id_fourth_made = Poster.fourth.id
    id_last_made = Poster.last.id
    poster_count = Poster.all.count
    expect(poster_count).to eq(5)

    posters = Poster.created_at_desc
    expect(posters.first.id).to eq(id_last_made)
    expect(posters.last.id).to eq(id_first_made)
    expect(posters.second.id).to eq(id_fourth_made)
    expect(posters.fourth.id).to eq(id_second_made)
    expect(posters.third.id).to eq(id_third_made)
  end
 
  it 'returns the posters with a price higher than the user input price(min_value)' do
    poster_1 = Poster.create(name: "REGRET",
      description: "Hard work rarely pays off.", 
      price: 25.00, 
      year: 2018, 
      vintage: true, 
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
 
     poster_2 = Poster.create(name: "FAILURE",
     description: "Why bother trying? It's probably not worth it.",
     price: 50.00,
     year: 2019,
     vintage: true,
     img_url: "https://t3.ftcdn.net/jpg/11/70/36/90/240_F_1170369060_uUGb9y0Crkbn6hIHwRtWcCdpMfSDBaqv.jpg")
 
     poster_3 = Poster.create(name: "MEDIOCRITY",
     description: "Dreams are just that—dreams.",
     price: 75.00,
     year: 2021,
     vintage: false,
     img_url: "https://t3.ftcdn.net/jpg/10/94/43/46/240_F_1094434660_eWqgET75FkLFBMKBz7kd5E3dYIM7tgpO.jpg")

    expect(Poster.min_price(30).count).to eq(2)
    expect(Poster.min_price(60).count).to eq(1)
    expect(Poster.min_price(10).count).to eq(3)
    expect(Poster.min_price(80).count).to eq(0)
    expect(Poster.all.count).to eq(3)
  end
end