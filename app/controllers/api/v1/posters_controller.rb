class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    render json: { data: PosterSerializer.format_posters(posters) }
  end

  def show
    poster = Poster.find(params[:id])
    render json: { data: PosterSerializer.format(poster) }
  end
end