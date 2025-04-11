class Api::V1::PostersController < ApplicationController
  def index
    if params[:min_price].present?
      min_price = params[:min_price].to_f
      posters = Poster.min_price(min_price)
    end

    if params[:max_price].present?
      max_price = params[:max_price].to_f
      posters = Poster.max_price(max_price)
    end
    
    if params[:sort] == 'desc'
      posters = Poster.created_at_desc
    else
       posters = Poster.order(created_at: :asc)
    end
    poster_count = Poster.all.count
    render json: { data: PosterSerializer.format_posters(posters),
    meta: { count: poster_count }
    }
  end

  def show
    poster = Poster.find(params[:id])
    render json: { data: PosterSerializer.format(poster) }
  end

  def create
    poster = Poster.create(poster_params)
    render json: { data: PosterSerializer.format(poster), }
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