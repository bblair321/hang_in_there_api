class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    render json: { data: PosterSerializer.format_posters(posters) }
  end

  def show
    poster = Poster.find(params[:id])
    render json: { data: PosterSerializer.format(poster) }
  end

destroy_poster
  def destroy
    poster = Poster.find(params[:id])

  def update
    poster = Poster.find(params[:id])
    Poster.update!(params[:id], poster_params)
    render json: { data: PosterSerializer.format(poster) }
      
  
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)

  end
end