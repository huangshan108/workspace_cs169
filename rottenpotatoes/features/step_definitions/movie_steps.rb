# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}.*/m
  assert_match page.source, regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  parse_ratings(rating_list).each do |rating|
    if uncheck
      uncheck_rating(rating)
    else
      check_rating(rating)
    end
  end
end

Then /I click 'refresh' button$/ do
  press_refresh
end

Then /I should see movies that are: (.*)/ do |rating_list|
  check_shown_movie(rating_list, true)
end

Then /^I should not see movies that are: (.*)/ do |rating_list|
  check_shown_movie(rating_list, false)
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  # rows = Movie.all.length
  page.find(:css, '#movie tr', :count => Movie.all.length, match: prefer_exact)
end

When /I select all the rating options/ do
  rating_list = "G,PG,PG-13,R"
end

Then /I should see all the rating options are selected/ do
  rating_list = "G,PG,PG-13,R"
  check_shown_movie(rating_list, true)
end

Then /the director of "(.*?)" should be "(.*?)"$/ do |arg1, arg2|
  regexp = /#{arg1}.*#{arg2}.*/m
  assert_match page.source, regexp
end

def parse_ratings(ratings)
  ratings.split(",").map(&:strip)
end

def uncheck_rating(rating)
  step(%{I uncheck "ratings_#{rating}"})
end

def check_rating(rating)
  step(%{I check "ratings_#{rating}"})
end

def press_refresh
  step(%{I press "ratings_submit"})
end

def check_shown_movie(rating_list, show)
  ratings = parse_ratings(rating_list)
  movies = Movie.where(:rating => ratings)
  within("#movies") do
    movies.map(&:title).each do |title|
      if show
        assert page.has_content?(title)  
      else
        assert !page.has_content?(title)  
      end
    end
  end
end