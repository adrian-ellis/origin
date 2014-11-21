###########################################################################################
###########################################################################################
# Scenario : Verify previews of all outfits are displayed on the "Buy the outfit" main page
###########################################################################################
###########################################################################################
Given /^I am on the ctshirts home page$/ do
  # navigate to home page
  @page = HomePage.new(@browser,@country)
end

And /^the Buy The Outfit link is displayed under the Style Hints Tips heading$/ do
  sleep 2

  #verfiy the style hints and tips heading (located above the 'buy the outfit' link) exists
  @page.style_hints_and_tips_heading.exists?.should == TRUE

  #check the 'buy the outfit' link exists
  @page.buy_the_outfit_link.exists?.should == TRUE
end


When /^I select Buy The Outfit$/ do
  #select buy the outfit link
  @page.buy_the_outfit_link.when_present.click
end

Then /^the Buy The Outfit page is displayed$/ do
  @page = BuyOutfitOverviewPage.new(@browser,@country)

  # verify we are on the buy the outfit page
  @page.url.should == BUY_THE_OUTFIT_OVERVIEW_PAGE
end

And /^it contains a carousel upon which the outfits are displayed$/ do |table|
  count_links = 0
  # verify caruosel exists and contains links to outfits
  @page.main_carousel.exists?.should == TRUE

  ###############################################
  # verify outfits are present on the carousel
  ###############################################
  @page.carousel_item_links.should_not == nil

  # Iterate through all the carousel items (ie. outfits). Verify there is a text description and a link url for each item.
  # Verify the text description matches with a corresponding row from this step's 'scenario table'.
  @page.carousel_item_links.each do |link|
    outfit_title = ''        # set to empty string before finding next outfit
    # The text description for the item is contained in 2 or more <cufontext> elements. Concatenate them to build the whole description.
    link.span(:class => "title").elements(:class => /cufon-canvas/).each do |cuftext|
      outfit_title.concat("#{cuftext.attribute_value("alt").downcase}")
    end
    outfit_title.strip!
    puts "\nINFO: Found '#{outfit_title}' on 'Buy The Outfit' overview page" if ENABLED_LOGGING

    # attempt to match the title we just retrieved from this webpage with the corresponding row of the scenario table (ie. for this step)
    found_outfit = FALSE
    table.hashes.each do |row|
      row.each do |key, val|
        if outfit_title == val.downcase.strip
          found_outfit = TRUE
          break
        end
      end
    end
    # Assert if there is a match, fail this test if no match is found
    fail "ERROR: Failed to match outfit '#{outfit_title}' to the outfits in scenario data table" if !found_outfit
    count_links+=1
  end

  # verify links to all 10 outfits exist
  fail "ERROR: Expected 10 outfits on 'Buy The Outfit' overview page" if count_links != TOTAL_NUMBER_OF_OUTFITS
end

##################################################################
##################################################################
# Scenario : Select an outfit from the Buy The Outfit carousel
##################################################################
##################################################################
Given /^I am on the Buy The Outfit page$/ do
  @page = HomePage.new(@browser,@country)

  #verfiy the style hints and tips heading (located above the 'buy the outfit' link) exists
  @page.style_hints_and_tips_heading.exists?.should == TRUE

  #check the 'buy the outfit' link exists
  @page.buy_the_outfit_link.exists?.should == TRUE
  #select buy the outfit link
  @page.buy_the_outfit_link.when_present.click
  @page = BuyOutfitOverviewPage.new(@browser,@country)

  # verify we are on the buy the outfit page
  @page.url.should == BUY_THE_OUTFIT_OVERVIEW_PAGE
end


When /^I select "(.*?)" from the Buy The Outfit carousel$/ do |outfit_type|
  @prev_url = @browser.url
  @page.carousel_item_classic_formal_link.when_present.click
end


Then /^the "(.*?)" page is displayed$/ do |outfit_type|
  @page = BuyOutfitDetailPage.new(@browser,@country)

  # verify that the outfit page is displayed. wait up to 15secs for it to appear.
  # this is an alternative to waiting for any specific page element to load (and there are lots of them!).
  @page.wait_until_page_loaded('Buy The Outfit - detail page', @prev_url)
  @page.wait_until_element_present(@page.page_header)
end


And /^it contains all the components for the "(.*?)"$/ do |outfit_type|
  @page.wait_until_element_present(@page.ajax_form)
end

And /^each component has a carousel upon which the alternative components are displayed$/ do
#pending
end


#################################################################################################################
#################################################################################################################
# Scenario : Cannot add outfit component "Jacket" to basket when Mandatory clothing measurement/option is missing
#################################################################################################################
#################################################################################################################
Given /^I am on the "(.*?)" page$/ do |outfit_type|
  #navigate to the outfit page
  @page = BuyOutfitDetailPage.new(@browser,@country)
  @page.visit_outfit_page
end

When /^I select Add To Basket next to the currently displayed jacket$/ do
  @page.add_jacket_to_basket.when_present.click
end

Then /^the "(.*?)" selection box is displayed and contains the text Please Select and is highlighted in red$/ do |mandatory_measurement|
  result = FALSE
  if mandatory_measurement.downcase == "jacket chest size"
    result = TRUE if @page.jacket_chest_size_selection_box.text.downcase.include? PROMPT_TO_SELECT
  elsif mandatory_measurement.downcase == "sleeve length"
    result = TRUE if @page.jacket_sleeve_length_selection_box.text.downcase.include? PROMPT_TO_SELECT
  end
  if result == FALSE
    puts "\nNo prompt found in #{mandatory_measurement} selection box"
    result.should == TRUE
  end
end

And /^I am unable to add this jacket to my basket$/ do
  @before = @page.get_number_of_items_in_basket
  @page.add_jacket_to_basket.when_present.click
  @after = @page.get_number_of_items_in_basket
  @after.should == @before
end


#################################################################################################################
#################################################################################################################
# Scenario : Can add outfit component to basket
#################################################################################################################
#################################################################################################################
When /^I select a value from the "(.*?)" selection box$/ do |mandatory_measurement|
  if mandatory_measurement.downcase == "jacket chest size"
    @page.jacket_chest_size_selection_box.when_present.click
    @page.select_jacket_chest_size_by_index(3).when_present.fire_event("onclick")
  elsif mandatory_measurement.downcase == "sleeve length"
    @page.jacket_sleeve_length_selection_box.when_present.click
    @page.select_sleeve_length_by_index(2).when_present.fire_event("onclick")
  end
end

And /^the currently displayed "(.*?)" is selected$/ do |outfit_component|
  puts "\njacket to be selected next" if outfit_component.downcase == "jacket"
end

And /^I select Add To Basket$/ do
  @before = @page.get_number_of_items_in_basket
  @page.add_jacket_to_basket.when_present.click
end

Then /^the "(.*?)" clothing item is added to my basket$/ do |outfit_component|
  # Wait (default is up to PAGE_ELEMENT_TIMEOUT_SECS secs) until the item has been added to the basket
  time_secs = 0
  while time_secs >= PAGE_ELEMENT_TIMEOUT_SECS
    @after = @page.get_number_of_items_in_basket
    break if (@after == @before + 1)
    fail "ERROR: Item failed to be added to the Basket" if (time_secs > PAGE_ELEMENT_TIMEOUT_SECS) && (@after != @before + 1)
    sleep 1
    time_secs+=1
  end
  puts "\nINFO: #{@after} item added to basket. End of test"
end


