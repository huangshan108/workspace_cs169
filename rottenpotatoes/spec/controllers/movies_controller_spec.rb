require 'spec_helper'

describe MoviesController do
  describe 'find movies from the same director' do
    before :each do
      @movie = double(Movie, :title => "THX-1138", :director => "George Lucas", :id => "14")
      Movie.stub(:find).with("14").and_return(@movie)
      @fake_results = [double('THX-1138'), double('George Lucas')]
    end
    it 'should call the model method that finds the movie by director' do
      Movie.should_receive(:same_director).with('George Lucas').and_return(@fake_results)
      post :index, {:find_by_director_movie_id => "14"}
    end
    it 'should select the find_by_director template for rendering' do
      Movie.stub(:same_director).with('George Lucas').and_return(@fake_results)
      post :index, {:find_by_director_movie_id => "14"}
      response.should render_template('find_by_director')
    end
    it 'should make the search results avilable to the template' do
      Movie.stub(:same_director).with('George Lucas').and_return(@fake_results)
      post :index, {:find_by_director_movie_id => "14"}
      assigns(:movies).should == @fake_results
    end
  end
end