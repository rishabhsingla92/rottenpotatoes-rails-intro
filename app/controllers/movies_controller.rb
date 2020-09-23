class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @movies = Movie.all
    #sort = params[:sort]
    #case sort
    #  when 'title'
    #    ordering,@title_header = {:order => :title}, 'hilite'
    #    @movies = Movie.order('title ASC')
    #  when 'release_date'
    #    ordering,@date_header = {:order => :release_date}, 'hilite'
    #    @movies = Movie.order('release_date ASC')
    
    @ratings_hash = Hash[*@all_ratings.map {|key| [key, 1]}.flatten]
    if (params[:session] == "clear")
      session[:sort] = nil
      session[:ratings] = nil
    end

    if (params[:ratings] != nil)
      @ratings_hash = params[:ratings]
      @movies = @movies.where(:rating => @ratings_hash.keys)
      session[:ratings] = @ratings_hash
    
    end
    
    if (params[:sort] != nil)
      case params[:sort]
      when "title"
        @movies = @movies.order(:title)
        @class_title = "hilite"
        session[:sort] = "title"
      when "release_date"
        @movies = @movies.order(:release_date)
        @class_release_date = "hilite"
        session[:sort] = "release_date"
      end
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
