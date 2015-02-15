class MoviesController < ApplicationController
  before_filter :setup_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @ratings_on = {}
    if params[:ratings] == nil
      if session[:ratings_on] == nil
        @all_ratings.each do |key|
          @ratings_on[key] = true
        end
        session[:ratings_on] = @ratings_on
      else
        @ratings_on = session[:ratings_on]
        @movies = Movie.find(:all, :conditions => {:rating => @ratings_on.keys})
      end
    else
      @movies = Movie.find(:all, :conditions => {:rating => params[:ratings].keys})
      params[:ratings].keys.each do |key|
        @ratings_on[key] = true
      end
      session[:ratings_on] = @ratings_on
    end
    if params[:sort] == "sort_movie_title" || session[:sorted_movie_title]
      @movies = @movies.sort_by{ |k| k["title"] }  
      session[:sorted_movie_title] = true
      session[:sorted_release_date] = nil
    elsif params[:sort] == "sort_release_date" || session[:sorted_release_date]
      @movies = @movies.sort_by{ |k| k["release_date"] }
      session[:sorted_release_date] = true
      session[:sorted_movie_title] = nil
    end
    @sorted_movie_title = session[:sorted_movie_title] || false
    @sorted_release_date = session[:sorted_release_date] || false
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
