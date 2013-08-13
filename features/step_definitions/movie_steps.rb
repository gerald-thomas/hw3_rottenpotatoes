# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    new_movie= Movie.create movie
    #debugger


  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
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
    rating_list.split(", ").each do |rating|
      # debugger
      if uncheck
        uncheck "ratings_#{rating}"
      else
        check "ratings_#{rating}"
      end    
  end
end

When /^I refresh the page/ do
  visit [ current_path, page.driver.request.env['QUERY_STRING'] ].reject(&:blank?).join('?')
end

Then /^I should see the following movies:$/ do |movies|
  # table is a Cucumber::Ast::Table
      selected_movies = movies.hashes
      # debugger
      selected_movies.each do |movie|
      assert page.body =~ /#{movie[:title]}/m, "#{movie[:title]} did not appear"
    end
end
