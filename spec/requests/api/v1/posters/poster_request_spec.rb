require "rails_helper"
require 'simplecov'
SimpleCov.start

RSpec.describe "Posters endpoints", type: :request do
  describe '#index' do
    it "returns a list of posters" do
      # only seed data (3 posters) exists now
      # binding.pry
      # expect(posters[:data].count).to eq(3)
      Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
      Poster.create(name: "FAILURE", description: "Why bother trying? It's probably not worth it.", price: 68.00, year: 2019, vintage: true, img_url: "https://t3.ftcdn.net/jpg/11/70/36/90/240_F_1170369060_uUGb9y0Crkbn6hIHwRtWcCdpMfSDBaqv.jpg")

      get "/api/v1/posters"
    
      expect(response).to be_successful
      posters = JSON.parse(response.body, symbolize_names: true)
  
      # should have made 2 more
      expect(posters[:data].count).to eq(5)

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

    it 'returns all posters in ascending order by created_at' do
      Poster.create(name: "REGRET",
       description: "Hard work rarely pays off.", 
       price: 89.00, 
       year: 2018, 
       vintage: true, 
       img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  
      Poster.create(name: "FAILURE",
      description: "Why bother trying? It's probably not worth it.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url: "https://t3.ftcdn.net/jpg/11/70/36/90/240_F_1170369060_uUGb9y0Crkbn6hIHwRtWcCdpMfSDBaqv.jpg")
  
      Poster.create(name: "MEDIOCRITY",
      description: "Dreams are just that—dreams.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url: "https://t3.ftcdn.net/jpg/10/94/43/46/240_F_1094434660_eWqgET75FkLFBMKBz7kd5E3dYIM7tgpO.jpg")
    
      get "/api/v1/posters?sort=asc"
      expect(response).to be_successful
    
      parsed = JSON.parse(response.body, symbolize_names: true)
      data = parsed[:data]
    
      expect(data.count).to eq(3)
    
      ordered_names = data.map { |poster| poster[:attributes][:name] }
      expect(ordered_names).to eq(["REGRET", "FAILURE", "MEDIOCRITY"])
    end

    it 'returns all posters in the database in descending order' do
      last_poster = Poster.last

      get "/api/v1/posters?sort=desc"
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      data = parsed_response[:data]
      first_poster_attributes = data.first[:attributes]

      expect(data.first[:id]).to eq(last_poster.id.to_s)
      expect(first_poster_attributes[:name]).to eq(last_poster.name)
      expect(first_poster_attributes[:description]).to eq(last_poster.description)
      expect(first_poster_attributes[:price]).to eq(last_poster.price.to_s)
      expect(first_poster_attributes[:year]).to eq(last_poster.year)
      expect(first_poster_attributes[:vintage]).to eq(last_poster.vintage)
      expect(first_poster_attributes[:img_url]).to eq(last_poster.img_url.to_s)
    end

    it 'returns all posters correctly that price >= the min_value' do
      Poster.first.update(price: 100)
      Poster.second.update(price: 30)
      Poster.last.update(price: 20)

      expect(Poster.all.count).to eq(3)

      get "/api/v1/posters?min_price=50"
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data].count).to eq(1)
      
      response_poster = parsed_response[:data].first[:attributes]

      expect(parsed_response[:data].first[:id]).to eq(Poster.first.id.to_s)
      expect(response_poster[:name]).to eq(Poster.first.name)
      expect(response_poster[:description]).to eq(Poster.first.description)
      expect(response_poster[:price]).to eq(Poster.first.price.to_s)
      expect(response_poster[:year]).to eq(Poster.first.year)
      expect(response_poster[:vintage]).to eq(Poster.first.vintage)
      expect(response_poster[:img_url]).to eq(Poster.first.img_url)
    end

    it "returns only posters with price less than or equal to max_price when param is given" do
    #  binding.pry
      Poster.create(name: "REGRET",
       description: "Hard work rarely pays off.", 
       price: 89.00, 
       year: 2018, 
       vintage: true, 
       img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  
      Poster.create(name: "FAILURE",
      description: "Why bother trying? It's probably not worth it.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url: "https://t3.ftcdn.net/jpg/11/70/36/90/240_F_1170369060_uUGb9y0Crkbn6hIHwRtWcCdpMfSDBaqv.jpg")
  
      Poster.create(name: "MEDIOCRITY",
      description: "Dreams are just that—dreams.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url: "https://t3.ftcdn.net/jpg/10/94/43/46/240_F_1094434660_eWqgET75FkLFBMKBz7kd5E3dYIM7tgpO.jpg")
    
      get "/api/v1/posters", params: { max_price: 88.00 }
    
      expect(response).to be_successful
      posters = JSON.parse(response.body, symbolize_names: true)
      # binding.pry
      # expect(posters[:data].count).to eq(1)
    
      returned_names = posters[:data].map { |poster| poster[:attributes][:name] }
    
      expect(returned_names).to include("FAILURE")
      expect(returned_names).not_to include("REGRET","MEDIOCRITY")
    end
  
    it "returns posters with a given search parameter" do
      Poster.create(name: "REGRET",
       description: "Hard work rarely pays off.", 
       price: 89.00, 
       year: 2018, 
       vintage: true, 
       img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  
      Poster.create(name: "FAILURE",
      description: "Why bother trying? It's probably not worth it.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url: "https://t3.ftcdn.net/jpg/11/70/36/90/240_F_1170369060_uUGb9y0Crkbn6hIHwRtWcCdpMfSDBaqv.jpg")
  
      Poster.create(name: "MEDIOCRITY",
      description: "Dreams are just that—dreams.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url: "https://t3.ftcdn.net/jpg/10/94/43/46/240_F_1094434660_eWqgET75FkLFBMKBz7kd5E3dYIM7tgpO.jpg")
    
      get "/api/v1/posters", params: { name: "re" }
    
      expect(response).to be_successful
      posters = JSON.parse(response.body, symbolize_names: true)
    # binding.pry
      # expect(posters[:data].count).to eq(2)
      returned_names = posters[:data].map { |poster| poster[:attributes][:name] }
    
      expect(returned_names).to include("REGRET", "FAILURE")
      expect(returned_names).not_to include("MEDIOCRITY")
    end
  end

  describe '#show' do
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

  describe '#update' do
    it 'can update a poster with details provided by user' do
      poster = Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
   
      params = {
        poster: {
          "name": "DEFEAT",
          "description": "It's REALLY too late to start now.",
          "price": 40.00,
          "year": 2024,
          "vintage": false,
          "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
        }
      }
      patch "/api/v1/posters/#{poster.id}", params: params
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      attributes = parsed_response[:data][:attributes]

      # or could use updated_poster = Poster.find(poster.id)

      updated_poster = poster.reload

      expect(updated_poster.name).to eq(params[:poster][:name])
      expect(updated_poster.name).to eq(attributes[:name])
      expect(updated_poster.description).to eq(attributes[:description])
      expect(updated_poster.description).to eq(params[:poster][:description])
      expect(updated_poster.price).to eq(attributes[:price].to_f)
      expect(updated_poster.price).to eq(params[:poster][:price])
      expect(updated_poster.year).to eq(attributes[:year])
      expect(updated_poster.year).to eq(params[:poster][:year])
      expect(updated_poster.vintage).to eq(attributes[:vintage])
      expect(updated_poster.vintage).to eq(params[:poster][:vintage])
      expect(updated_poster.img_url).to eq(attributes[:img_url])
      expect(updated_poster.img_url).to eq(params[:poster][:img_url])
    end
  end

  describe '#destroy' do
    it 'destorys a poster by id and outputs a 204 response' do

      pre_run_poster_count = Poster.all.count

      poster_1 = Poster.create!(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
      poster_2 = Poster.create!(name: "BORN TO BE DELETED",description: "Why bother trying? It's probably not worth it.",price: 68.00,year: 2019,vintage: true,img_url: "https://t3.ftcdn.net/jpg/11/70/36/90/240_F_1170369060_uUGb9y0Crkbn6hIHwRtWcCdpMfSDBaqv.jpg")
      id=poster_2.id

      original_poster_count = Poster.all.count

      expect(Poster.where(name: "BORN TO BE DELETED")).to eq([poster_2])

      delete "/api/v1/posters/#{poster_2.id}"
    
      expect(response.status).to eq(204)
      expect(response.body).to eq('')
      expect(Poster.find_by(id: id)).to eq(nil)
      expect(original_poster_count -1).to eq(Poster.all.count)
      expect(Poster.where(name: "BORN TO BE DELETED")).to eq([])
    end
  end

  describe '#create' do
    it 'creates a poster and adds it to the database' do
      params = {
        poster: {
        "name": "JOKES",
        "description": "It's too late to start now.",
        "price": 35.00,
        "year": 2023,
        "vintage": false,
        "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
        }
      }

      post "/api/v1/posters", params: params

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      poster_attributes = parsed_response[:data][:attributes]
      poster_params = params[:poster]
      created_poster = Poster.last

      expect(poster_attributes[:name]).to eq(poster_params[:name])
      expect(poster_attributes[:name]).to eq(created_poster[:name])
      expect(poster_attributes[:description]).to eq(poster_params[:description])
      expect(poster_attributes[:description]).to eq(created_poster[:description])
      expect(poster_attributes[:price]).to eq(poster_params[:price].to_s)
      expect(poster_attributes[:price]).to eq(created_poster[:price].to_s)
      expect(poster_attributes[:year]).to eq(poster_params[:year])
      expect(poster_attributes[:year]).to eq(created_poster[:year])
      expect(poster_attributes[:vintage]).to eq(poster_params[:vintage])
      expect(poster_attributes[:vintage]).to eq(created_poster[:vintage])
      expect(poster_attributes[:img_url]).to eq(poster_params[:img_url])
      expect(poster_attributes[:img_url]).to eq(created_poster[:img_url])
    end
  end
end

