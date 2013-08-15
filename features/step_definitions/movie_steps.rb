# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    new_movie= Movie.create movie
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see movie "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # "[movie|release_date]"
  assert_operator page.body.index(e1), :< , page.body.index(e2)
end

Then /I should see release_date "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # "[movie|release_date]"
    e1_date=DateTime.parse(e1).strftime('%F')
    e2_date=DateTime.parse(e2).strftime('%F')
    assert_operator page.body.index(e1_date), :< , page.body.index(e2_date)
  # flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list| 
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  # debugger
  # assert_equal uncheck, "un"
    rating_list.scan(%r{\w[\w\-]*}).each do |rating|
      
      if uncheck
        # debugger
        uncheck "ratings_#{rating}"
      else
        check "ratings_#{rating}"
      end    
  end
end


When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end


# When /^I refresh the page/ do
#   visit [ current_path, page.driver.request.env['QUERY_STRING'] ].reject(&:blank?).join('?')
# end

Then /^I should see the following movies:$/ do |movies|
  # table is a Cucumber::Ast::Table
      selected_movies = movies.hashes
      # debugger
      selected_movies.each do |movie|
      assert page.body =~ /#{movie[:title]}/m, "#{movie[:title]} did not appear"
    end
end


# Then /^I should see movies with ratings: (.*)$/ do |rating_list|
#   rating_list.scan(%r{\w[\w\-]*}).each do |rating|
#     movie.rating.should_equal rating
#   end
# end

Then /^I should see all movies with ratings:(.*)$/ do |rating_list|
  rating_list.scan(%r{\w[\w\-]*}).each do |rating|
    # debugger
      all_movies_with_rating=Movie.find_all_by_rating(rating) 
      all_movies_with_rating.each do |rated_movie|
        assert page.body =~ /#{rated_movie[:title]}/m, "#{rated_movie[:title]} did not appear"
      end
    end
end



Then /^I should not see movies with ratings:(.*)$/ do |rating_list|
  # debugger
  rating_list.scan(%r{\w[\w\-]*}).each do |rating|
  all_movies_with_rating=Movie.find_all_by_rating(rating)
  all_movies_with_rating.each do |rated_movie|
        text = "#{rated_movie[:title]}"
        if page.respond_to? :should
          page.should have_no_content(text)
        else
          assert page.has_no_content?(text)
        end
      end
  end 
end

Given /^all ratings are selected$/ do
  Movie.all_ratings.each do |rating|
    check "ratings_#{rating}"
  end
end

Given /^no ratings are selected$/ do
  Movie.all_ratings.each do |rating|
    uncheck "ratings_#{rating}"
  end
end


Then /^I should see all the movies$/ do
  all_movies_count= Movie.all.count
  page.all('table#movies tr').count.should == 11
end

Then /^I should see no movies$/ do
  page.all('table#movies tr').count.should == 11
end


Then /^show me the page$/ do
  save_and_open_page
end