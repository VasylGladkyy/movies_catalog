class MoviesController < ApplicationController
  before_action :authenticate_user!, only: %i[show add_to_watch_later watch_later destroy_watch_later]

  def index
    @movies = Movie.search_by_title(title: params[:title])
  end

  def show
    @movie = movie
  end

  def add_to_watch_later
    @movie = movie
    @user = user
    authorize @movie
    if @user.save_movie?(movie: @movie)
      flash[:success] = 'Movie added to later watch list'
    else
      flash[:error] = 'Added movie is present in watch later list!'
    end
    respond_to do |format|
      format.html { redirect_to @movie }
      format.js
    end
  end

  def watch_later
    @user = User.find(params[:id])
    @movies = @user.movies
  end

  def destroy_watch_later
    @user = user
    authorize @user
    @user.movies.delete(movie)
    respond_to do |format|
      format.html { redirect_to watch_later_movie_path(@user) }
      format.js
    end
  end

  def autocomplete
    render json: Movie.search(params[:title], {
      fields: ["title"],
      match: :text_middle,
      limit: 5,
      load: false,
      missoellings: { bellow: 5 }
    }).map(&:title)
  end

  protected

  def movie
    Movie.find(params[:id])
  end

  def user
    current_user
  end
end
