require 'spec_helper'

describe Movie do
	it 'has a director' do
	  Movie.new.should respond_to :director
	end
end