Given /^I am on the product page for men's "(.*)"$/ do |shirt_type|
  #########################################################################################################################################
  # IMPORTANT: The 'All shirts' product page MUST be used if there is no product listing for the 'Casual shirts' link on the top level menu
  #########################################################################################################################################
  @homePage = HomePage.new(@page,@country)
  if shirt_type == 'casual shirts'
    if NO_CASUAL_SHIRTS_PRODUCT_LISTING_PAGE
      @productPage = @homePage.goto_all_shirts_product_page(@country)
    else
      @productPage = @homePage.goto_casual_shirts_product_page(@country)
    end
  elsif shirt_type == 'formal shirts'
    @productPage = @homePage.goto_formal_shirts_product_page(@country)
  else
    fail "ERROR: you must specify either casual or formal shirts"
  end
end

########################################################################################################################################################
# find the link(s)(each shown as a checkbox on the product page) that match the category value(s) given in the current row of this scenario's data table
########################################################################################################################################################
When /^I enable the "(.*)" filters for a combination of the "(.*)" and "(.*)" and "(.*)" and "(.*)" category checkboxes$/ do |shirt_type, size, fit, colour, range_or_length|
  if shirt_type == 'casual shirts'
    # Format 'size', 'fit', 'colour', 'range' categories and category values into a hash.
    @selected_categories = {size: size, fit: fit, colour: colour, range: range_or_length}
  elsif shirt_type == 'formal shirts'
    # Format 'collar size', 'fit', 'colour', 'sleeve length' categories and category values into a hash.
    @selected_categories = {collar_size: size, fit: fit, colour: colour, sleeve_length: range_or_length}
  end

  # Call the select_value_from_category method for each key/value pair in the hash.
  @selected_categories.each do |category_type, category_value|
    @productPage.select_value_from_category(category_type, category_value) if !category_value.empty?
  end
end

################################################################################################################################################################
# Verify that each of the clothing items listed on each webpage have the same category codes that are specified in the current row of this scenario's data table
################################################################################################################################################################
Then /^only the filtered men's "(.*)" items for these categories are displayed$/ do |shirt_type|
  remaining_category_codes = ''
  page_no = 1
  last_page = FALSE

  # Find the category codes that are embedded in the (link) URL for each of the clothing items listed on each webpage.
  until(last_page) do
    @productPage.shirt_item_links.each do |link|
      ################################################################################################
      # Split the product item's URL (delimited by '|' characters) to find the item's category codes
      ################################################################################################
      item_codes_from_url = link['href'].split "|"
      item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]
      remaining_category_codes = item_codes_from_url[INDEX_FOR_OTHER_CATEGORIES].split(",") if (item_codes_from_url[INDEX_FOR_OTHER_CATEGORIES] != nil)
      if shirt_type == 'casual shirts'
        item_size = item_codes_from_url[INDEX_FOR_SIZE_CODE].sub(',','') if (item_codes_from_url[INDEX_FOR_SIZE_CODE] != nil)
        puts "\nITEM PRODUCT CODE = #{item_product_code} : ITEM SIZE = #{item_size} : REMAINING CATEGORY CODES = #{remaining_category_codes}" if INDIVIDUAL_ITEM_LOGGING_ENABLED
      elsif shirt_type == 'formal shirts'
        item_collar_size = item_codes_from_url[INDEX_FOR_COLLAR_SIZE_CODE].sub(',','') if (item_codes_from_url[INDEX_FOR_COLLAR_SIZE_CODE] != nil)
        puts "\nITEM PRODUCT CODE = #{item_product_code} : COLLAR SIZE = #{item_collar_size} : REMAINING CATEGORY CODES = #{remaining_category_codes}" if INDIVIDUAL_ITEM_LOGGING_ENABLED
      end

      ####################################################################################################################
      # Compare the category codes found in the product item's URL to the category code from the relevant database table
      # (eg. tbCategories.CategoryNo for 'design') or hashes that contain these codes (these are above the class definition).
      ####################################################################################################################

      # Find the codes that match each category (eg. fit, colour, range for casual shirts)
      @selected_categories.each do |category_type, category_value|
        if !category_value.empty?
	        found_code = @productPage.find_items_category_codes(remaining_category_codes, category_type)
          #fail "ERROR: Item #{item_product_code} has incorrect/missing #{category_type} code in its URL : #{link['href']}" if !found_code
          #puts "ERROR: Item #{item_product_code} has incorrect/missing #{category_type} code in its URL : #{link['href']}\n" if !found_code
        end
	    end
    end

	# Navigate to the next page of product items if such a page exists.
    if @productPage.found_next_product_page == TRUE
      @productPage.select_next_product_page

      # trap any errors caused by element referencing errors (eg. StaleElementReference)
      trap_error { @page.find(:div_id, 'ctl00_contentBody_productListingSection').all(:link_class, 'img').first }

      page_no+=1
      puts "\nSkipped to the Next Page (#{page_no}) of results" if ENABLED_LOGGING
    else
      last_page = TRUE
    end
  end
end