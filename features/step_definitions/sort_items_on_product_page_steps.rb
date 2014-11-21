Given /^I am on the men's casual shirts product page$/ do
  #########################################################################################################################################
  # IMPORTANT: The 'All shirts' product page MUST be used if there is no product listing for the 'Casual shirts' link on the top level menu
  #########################################################################################################################################
  if NO_CASUAL_SHIRTS_PRODUCT_LISTING_PAGE
    @productPage = @page.goto_all_shirts_product_page(@country)
  else
    @productPage = @page.goto_casual_shirts_product_page(@country)
  end
end


When /^I sort the clothing items on the this page by the parameter "(.*?)"$/ do |sorting_parameter|
  # check that sorting_parameter is valid
  found_string = FALSE
  index = 0
  valid_sort_strings = ["Relevance", "Name (A-Z)", "Name (Z-A)", "Price (lowest)", "Price (highest)"]
  valid_sort_strings.each do |string|
    if sorting_parameter.downcase == string.downcase
      found_string = TRUE
      break	  
    end
    # set index according to value in scenario data table
    index+=1
  end
  fail "ERROR: #{sorting_parameter} is not a valid sorting parameter" if found_string != TRUE
  @productPage.wait_until_element_present(@productPage.first_shirt_item_link)
  @productPage.sort_by_link(index).fire_event("onclick")
end


Then /^the product items are displayed on the "(.*?)" page ordered by the parameter "(.*?)"$/ do |product_type, sorting_parameter|
  all_item_codes           = []
  all_item_names           = []
  sorted_all_item_names    = []
  all_item_names_lowercase = []
  all_item_prices          = []
  total_item_count         = 0
  no_more_pages            = FALSE

  # Find the category codes that are embedded in the (link) URL for each of the clothing items listed on each webpage.
  until(no_more_pages)
    @productPage.clothing_item_container_elements.each do |cont|
      cont.lis(:class => /.*/).each do |element|
        ################################################################################################
        # Split the product item's URL (delimited by '|' characters) to find the item's category codes
        ################################################################################################
        @productPage.wait_until_element_present(element.link(:class => "img", :href => /shirts/))
        item_codes_from_url = element.link(:class => "img", :href => /shirts/).href.split "|"
        item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]
        item_price = element.p(:class => "price").ins(:class => /.*/).text.sub(/[^\d]/,"")
        item_name = element.h3(:class => /.*/).link(:href => /shirts/).text
        all_item_codes.push(item_product_code)
        all_item_names.push(item_name)
        all_item_prices.push(Decimal(item_price))
        puts "\nINFO: Item no. '#{total_item_count + 1}' has CODE:\'#{item_product_code}\': NAME:\'#{item_name}\': ITEM PRICE:\'#{item_price}\'" if INDIVIDUAL_ITEM_LOGGING_ENABLED
        total_item_count+=1
      end
    end

    # Navigate to the next page of product items if such a page exists.
    if @productPage.found_next_product_page
      prev_url = @browser.url
	    @productPage.select_next_product_page

      # wait for the page to reload after selecting next page (otherwise it will search for a non-existent item on the previous page)
      @productPage.wait_until_page_loaded('All Shirts Product Page', prev_url)

      # wait for the first item to load on the current product page
	    @productPage.wait_until_element_present(@productPage.first_shirt_item_link)
    else
      no_more_pages = TRUE
    end
  end

  index = 0
  case
    when sorting_parameter == "Price (lowest)"
      ###############################################################################################################################################
      # Do the comparison by price ASCENDING
      ###############################################################################################################################################
      while index < total_item_count - 1
        if all_item_prices[index] > all_item_prices[index+1]
          fail "ERROR: #{all_item_codes[index]} price #{all_item_prices[index]} should be not be greater than #{all_item_codes[index+1]} price #{all_item_prices[index+1]}"
        end
        index+=1
      end
    when sorting_parameter == "Price (highest)"
      ###############################################################################################################################################
      # Do the comparison by price DESCENDING
      ###############################################################################################################################################
      while index < total_item_count - 1
        if all_item_prices[index] < all_item_prices[index+1]
          fail "ERROR: #{all_item_codes[index]} price #{all_item_prices[index]} should be not be less than #{all_item_codes[index+1]} price #{all_item_prices[index+1]}"
        end
        index+=1
      end
    when sorting_parameter == "Name (A-Z)" || sorting_parameter == "Name (Z-A)"
      ################################################################################################################################################
      # Do the comparison by name (ie. alphabetically by either ASC or DESC), after converting to lower case (as mixed case affects the sorting result)
      ################################################################################################################################################
      all_item_names.each { |name| sorted_all_item_names.push(name.downcase) }
      all_item_names.each { |name| all_item_names_lowercase.push(name.downcase) }
  	  if sorting_parameter == "Name (A-Z)"
        sorted_all_item_names.sort!
      else
        sorted_all_item_names.sort!.reverse!
      end	  
      while index < total_item_count - 1
        if sorted_all_item_names[index] != all_item_names_lowercase[index]
          fail "ERROR: Items are not in #{sorting_parameter} order. Mismatch occurred at '#{all_item_names[index]}', which has item code \'#{all_item_codes[index]}\', within the \'#{total_item_count}\' items listed"
        end
        index+=1
      end
    when sorting_parameter == Relevance
      #do the comparison by relevance - what determines this?
  end
end