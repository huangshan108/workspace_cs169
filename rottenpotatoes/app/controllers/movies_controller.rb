class MoviesController < ApplicationController
  before_filter :setup_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:find_by_director_movie_id]
      find_by_director(params[:find_by_director_movie_id])
      return
    end

    # print "xxx: ", params, "\n"
    @movies = Movie.all
    @ratings_on = {}
    # print "params[:ratings]: ", params[:ratings], "\n"
    # Handles redirects only. Does not do any db or rendering stuffs.
    if params[:ratings] == nil
      if session[:ratings_on] == nil || session[:ratings_on] == {}
        @all_ratings.each do |key|
          @ratings_on[key] = true
        end
        session[:ratings_on] = @ratings_on
      end
    else
      session[:ratings_on] = params[:ratings]
    end
    # puts "session[:ratings_on]: ", session[:ratings_on]
    if params[:sort] == nil
      # print "session[:sorted_movie_title]: ", session[:sorted_movie_title]
      if session[:sorted_movie_title]
        redirect_to movies_path :ratings => session[:ratings_on], :sort => 'sort_movie_title', :director => params[:director], :no_title => params[:no_title]
        return
      elsif session[:sorted_release_date]
        redirect_to movies_path :ratings => session[:ratings_on], :sort => 'sort_release_date', :director => params[:director], :no_title => params[:no_title]
        return
      else # first time visiter
        redirect_to movies_path :ratings => session[:ratings_on], :sort => 'unsorted', :director => params[:director], :no_title => params[:no_title]
        return
      end
        
    elsif params[:ratings] == nil
      redirect_to movies_path :ratings => session[:ratings_on], :sort => params[:sort], :director => params[:director], :no_title => params[:no_title]
      return
    end

    @movies = Movie.find(:all, :conditions => {:rating => params[:ratings].keys})
    params[:ratings].keys.each do |key|
      @ratings_on[key] = true
    end
    session[:ratings_on] = @ratings_on
    # puts "params[:sort]: ", params[:sort]
    if params[:sort] == "sort_movie_title"
      @movies = @movies.sort_by{ |k| k["title"] }  
      session[:sorted_movie_title] = true
      session[:sorted_release_date] = nil
    elsif params[:sort] == "sort_release_date"
      @movies = @movies.sort_by{ |k| k["release_date"] }
      session[:sorted_release_date] = true
      session[:sorted_movie_title] = nil
    end
    @sorted_movie_title = session[:sorted_movie_title] || false
    @sorted_release_date = session[:sorted_release_date] || false
  end

  def find_by_director(id)
    @current_movie = Movie.find(id)
    @no_director_info = false
    if @current_movie.director == nil
      @no_director_info = true
      @movies = Movie.where(:id => id)
    else
      @movies = Movie.same_director(@current_movie.director)
    end
    render 'find_by_director'
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
