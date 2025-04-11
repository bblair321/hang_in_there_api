class Api::V1::PostersController < ApplicationController
  def index
    # posters = Poster.all
    if params[:min_price].present?
      min_price = params[:min_price].to_f
      posters = Poster.min_price(min_price)
    end
    # poster_count = Poster.all.count
    render json: { data: PosterSerializer.format_posters(posters) }
  end

  def show
    poster = Poster.find(params[:id])
    render json: { data: PosterSerializer.format(poster) }
  end

  def create
    poster = Poster.create(poster_params)
    render json: { data: PosterSerializer.format(poster) }
  end

  def destroy
    poster = Poster.find(params[:id])
    poster.destroy
  end
  
  def update
    poster = Poster.find(params[:id])
    poster.update(poster_params)
    render json: { data: PosterSerializer.format(poster) }
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end