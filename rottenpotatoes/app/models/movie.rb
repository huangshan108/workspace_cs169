class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director
  def self.same_director(director)
  	return Movie.find(:all, :conditions => {:director => director})
  end
end
