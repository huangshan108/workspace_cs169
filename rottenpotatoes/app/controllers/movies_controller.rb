class MoviesController < ApplicationController
  before_filter :setup_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings] == nil
      @movies = []
      return
    end
    @ratings_on = {}
    @movies = Movie.find(:all, :conditions => {:rating => params[:ratings].keys})
    params[:ratings].keys.each do |key|
      @ratings_on[key] = true
    end
    @sorted_movie_title = false
    @sorted_release_date
    if params[:sort] == "sort_movie_title"
      @movies = @movies.sort_by{ |k| k["title"] }  
      @sorted_movie_title = true
    elsif params[:sort] == "sort_release_date"
      @movies = @movies.sort_by{ |k| k["release_date"] }
      @sorted_release_date = true
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  def setup_ratings
    @all_ratings = ['G','PG','PG-13','R']
  end
end
