class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    
    if params[:min_price].present?
      min_price = params[:min_price].to_f
      posters = posters.min_price(min_price)
    end

    if params[:max_price].present?
      max_price = params[:max_price].to_f
      posters = posters.max_price(max_price)
    end
    
    if params[:sort] == 'desc'
      posters = posters.created_at_desc
    else
       posters = posters.order(created_at: :asc)
    end

    if params[:name].present?
      posters = posters.name_contains(params[:name])
    end
    
    render json: { data: PosterSerializer.format_posters(posters),
    meta: { count: posters.count }
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