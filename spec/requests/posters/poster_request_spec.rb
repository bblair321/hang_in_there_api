require "rails_helper"
require 'simplecov'
SimpleCov.start

RSpec.describe "Posters endpoints", type: :request do
  it "returns a list of posters" do
    Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
    Poster.create(name: "FAILURE", description: "Why bother trying? It's probably not worth it.", price: 68.00, year: 2019, vintage: true, img_url: "https://t3.ftcdn.net/jpg/11/70/36/90/240_F_1170369060_uUGb9y0Crkbn6hIHwRtWcCdpMfSDBaqv.jpg")

    get "/api/v1/posters"
    
    expect(response).to be_successful
    posters = JSON.parse(response.body, symbolize_names: true)
    
    expect(posters[:data].count).to eq(2)

    posters[:data].each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_an(String)
      expect(poster).to have_key(:type)
      expect(poster[:type]).to eq("poster")

      attributes = poster[:attributes]
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:price)
      expect(attributes[:price].to_f).to be_a(Float)

      expect(attributes).to have_key(:year)
      expect(attributes[:year]).to be_an(Integer)

      expect(attributes).to have_key(:vintage)
      expect(attributes[:vintage]).to eq(true).or eq(false)

      expect(attributes).to have_key(:img_url)
      expect(attributes[:img_url]).to be_a(String)
    end
  end

  it "can get return one poster" do
    poster_1 = Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
  
    get "/api/v1/posters/#{poster_1.id}"
  
    expect(response).to be_successful
  
    poster_response = JSON.parse(response.body, symbolize_names: true)
  
    expect(poster_response[:data]).to have_key(:id)
    expect(poster_response[:data][:id]).to eq(poster_1.id.to_s)
  
    expect(poster_response[:data]).to have_key(:type)
    expect(poster_response[:data][:type]).to eq("poster")
  
    attributes = poster_response[:data][:attributes]
  
    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to eq(poster_1.name)
  
    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to eq(poster_1.description)
  
    expect(attributes).to have_key(:price)
    expect(attributes[:price].to_f).to eq(poster_1.price)
  
    expect(attributes).to have_key(:year)
    expect(attributes[:year]).to eq(poster_1.year)
  
    expect(attributes).to have_key(:vintage)
    expect(attributes[:vintage]).to eq(poster_1.vintage)
  end
end
