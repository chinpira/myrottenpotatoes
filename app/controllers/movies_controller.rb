class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    params_changed = false
    if session.has_key? :ratings
      unless params.has_key? :ratings
        params[:ratings] = session[:ratings]
        params_changed = true
      end
    end
    if session.has_key? :sort
      unless params.has_key? :sort
        params[:sort] = session[:sort]
        params_changed = true
      end
    end
    if params_changed
      flash.keep
      redirect_to movies_path(params)
    end
    
    sort_by = params[:sort]
    if params.has_key?(:ratings)
      ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
    else
      ratings = []
    end  
    params.has_key?(:ratings) ? @ratings_selected = params[:ratings].keys : @ratings_selected = []
    @all_ratings = Movie.possible_ratings
    puts "Here are ratings: #{ratings}"
    #@all_ratings = ['G','PG','PG-13','R']
    if sort_by == "sortByTitle"
      @movies = Movie.find(:all, :order => 'title ASC', :conditions => [ "rating IN (?)", ratings])
    elsif sort_by == "sortByDate"
      @movies = Movie.find(:all, :order => 'release_date ASC', :conditions => [ "rating IN (?)", ratings])
    else
      @movies = Movie.find(:all, :conditions => [ "rating IN (?)", ratings])
    end
    session[:sort] = sort_by
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

end
