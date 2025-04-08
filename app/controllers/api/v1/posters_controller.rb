class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    render json: { data: PosterSerializer.serialize_collection(posters) }
  end
end