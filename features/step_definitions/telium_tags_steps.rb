##############################################################################################################################################################
##############################################################################################################################################################
###################     Step Definitions for Scenario: 'Telium' Tags are present within the Product page when I am NOT logged in      ########################
##############################################################################################################################################################
##############################################################################################################################################################
Given /^I am not logged in to my account in country "(.*)"$/ do |country|
  @country = country
  @page = HomePage.new(@browser,@country)
end

When /^I navigate to the product page for "(.*)"$/ do |product_type|
  if product_type.downcase == "casual shirts"
    # If the 'Casual shirts' page has not been configured (in Mercado or Fred Hopper) to display a product listing
    # (ie. and we set NO_CASUAL_SHIRTS_PRODUCT_LISTING_PAGE to TRUE in env.rb.watir) then load the 'All shirts' page instead.
    if NO_CASUAL_SHIRTS_PRODUCT_LISTING_PAGE
      @productPage = @page.goto_all_shirts_product_page(@country)
    else
      @productPage = @page.goto_casual_shirts_product_page(@country)
    end
    @product_type = CASUAL_SHIRTS
  elsif product_type.downcase == "formal shirts"
    @productPage = @page.goto_formal_shirts_product_page(@country)
    @product_type = FORMAL_SHIRTS
  end
  @page_type = PAGE_TYPE['ProductListing']
end

Then /^the site_currency, site_region, page_name, page_type, campaign_source, campaign_url_code and product_sku tags are present and have the expected values$/ do
  #############################################     "PRODUCT LISTING PAGE"   #######################################################
  ##################################################################################################################################
  # The 'product_listing_page' hash is used to store the data that the Telium tag javascript data must be compared against.
  # 'product_listing_page' is to be filled with the appropriate values from the scenario data table and the current web page.
  ##################################################################################################################################
  user_logged_in = FALSE
  @customer_email_address = ''
  product_listing_page_data = @productPage.get_core_page_data(@customer_email_address, @page_type)
  top_row_product_items = @productPage.get_top_row_items
  product_listing_page_data.merge!("product_sku" => top_row_product_items)

  # Read the Telium javascript data into the hash 'utag_hash'
  utag_hash = @productPage.get_utag_javascript_variables(user_logged_in, @page_type)

  # The comparison between this page's data (for this Scenario) and utag_hash that passes/fails this test.
  if ENABLED_LOGGING
    puts "\n\nINFO: ######## 'product_listing_page_data' and 'utag_data' hash keys/values ########"
    utag_hash.each { |key,val| puts "\nINFO: product_listing_page_data '#{key}' => '#{product_listing_page_data[key]}' :  utag_hash '#{key}' => '#{utag_hash[key]}'" }
  end
  utag_hash.each { |key, val| utag_hash[key].should == product_listing_page_data[key] }
end



###############################################################################################################################################################
###############################################################################################################################################################
#--------------------   Step definitions common to the following Scenarios:   -------------------------------------------------------------------------------##
##################         'Telium' Tags are present within the PRODUCT PAGE when I am logged in to my account                #################################
#################          'Telium' Tags are present and correct within the LOGIN PAGE when I am logged in to my account     ##################################
################           'Telium' Tags are present and correct within the HOME PAGE when I am logged in to my account     ###################################
###############################################################################################################################################################
###############################################################################################################################################################
Given /^I log in to my account with "(.*)" and "(.*)" in country "(.*)"$/ do |email_address, password, country|
  # Use instance variables so they can be used by other step definitions within the same file Its not ideal, but it makes sense to keep the feature tidier
  # and more readable this way. Also if some of the parameters change (or get added/removed) then the feature file will require less maintenance.
  @customer_email_address = email_address
  @country = country

  # Load the Home page, select 'Login' and provide the email address and password to log in to the account (that has already been created independently of this test)
  @homePage = HomePage.new(@browser,country)
  @loginPage = @homePage.visit_loginpage
  @accountPage = @loginPage.login_with(email_address, password)

  # provide an alias for '@accountPage' that can be used for other step definitions that follow on from this one (eg. for the scenario when the user is NOT logged in)
  @page = @accountPage
  @page_type = PAGE_TYPE['Preferences']
end

When /^I navigate to the Home page$/ do
  @homePage = @page.navigate_to_home_page(@country)
  @page = @homePage       # set this to '@page' so that can it be used for other any step definitions that follow on from this one
  @page_type = PAGE_TYPE['Home']
end

Then /^the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source and campaign_url_code tags are present and have the expected values$/ do
  ##################################   "LOGIN (MY ACCOUNT) PAGE" and "HOME PAGE" ###################################################
  ##################################################################################################################################
  # The 'login_page_data' hash is used to store the data that the Telium tag javascript data must be compared against.
  # 'login_page_data' is to be filled with the appropriate values from the scenario data table and the current web page.
  ##################################################################################################################################
  login_page_data = @page.get_core_page_data(@customer_email_address, @page_type)

  # Read the Telium javascript data into the hash 'utag_hash'
  user_logged_in = TRUE
  utag_hash = @page.get_utag_javascript_variables(user_logged_in, @page_type)

  # The first part of the comparison between the page's data (for this scenario) and utag_hash that passes/fails this test.
  puts "\n\nINFO: utag_data hash gives the customer_id (before its removal) of '#{utag_hash["customer_id"][/^[\d]+$/]}'" if ENABLED_LOGGING
  utag_hash["customer_id"][/^[\d]+$/].should_not == nil                 # cannot verify customer_id outside of the database so check it's a string that contains only digits
  utag_hash.delete("customer_id")                                       # remove customer_id so we can do a simple comparison between hashes basket_page_data and utag_hash

  # The comparison between this page's data (for this Scenario) and utag_hash that passes/fails this test.
  if ENABLED_LOGGING
    puts "\n\nINFO: ######## 'login_page_data' and 'utag_data' hash keys/values ########"
    utag_hash.each { |key,val| puts "\nINFO: login_page_data '#{key}' => '#{login_page_data[key]}' :  utag_hash '#{key}' => '#{utag_hash[key]}'" }
  end
  utag_hash.each { |key, val| utag_hash[key].should == login_page_data[key] }
end

Then /^the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source, campaign_url_code and product_sku tags are present and have the expected values$/ do
  #######################################     "PRODUCT LISTING PAGE (logged in)"   #################################################
  ##################################################################################################################################
  # The 'product_listing_page' hash is used to store the data that the Telium tag javascript data must be compared against.
  # 'product_listing_page' is to be filled with the appropriate values from the scenario data table and the current web page.
  ##################################################################################################################################
  @page_type = PAGE_TYPE['ProductListing']
  product_listing_page = @productPage.get_core_page_data(@customer_email_address, @page_type)
  top_row_product_items = @productPage.get_top_row_items
  product_listing_page.merge!("product_sku" => top_row_product_items)

  # Read the Telium javascript data into the hash 'utag_hash'
  user_logged_in = TRUE
  utag_hash = @productPage.get_utag_javascript_variables(user_logged_in, @page_type)

  # The first part of the comparison between the page's data (for this scenario) and utag_hash that passes/fails this test.
  puts "\n\nINFO: utag_data hash gives the customer_id (before its removal) of '#{utag_hash["customer_id"][/^[\d]+$/]}'" if ENABLED_LOGGING
  utag_hash["customer_id"][/^[\d]+$/].should_not == nil                 # cannot verify customer_id outside of the database so check it's a string that contains only digits
  utag_hash.delete("customer_id")                                       # remove customer_id so we can do a simple comparison between hashes basket_page_data and utag_hash

  # The comparison between this page's data (for this Scenario) and utag_hash that passes/fails this test.
  if ENABLED_LOGGING
    puts "\n\nINFO: ######## 'product_listing_page' and 'utag_data' hash keys/values ########"
    utag_hash.each { |key,val| puts "\nINFO: product_listing_page '#{key}' => '#{product_listing_page[key]}' :  utag_hash '#{key}' => '#{utag_hash[key]}'" }
  end
  utag_hash.each { |key, val| utag_hash[key].should == product_listing_page[key] }
end



#######################################################################################################################################################################################
#######################################################################################################################################################################################
##################     Step Definitions for Scenario: 'Telium' Tags are present within the BASKET PAGE when I am logged in, and have items in my basket       #########################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
Then /^the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source, campaign_url_code, product_sku, product_name, product_unit_price and product_quantity tags are present and have the expected values$/ do
  item_codes                  = []
  item_names                  = []
  item_prices                 = []
  item_qtys                   = []
  proper_item_names           = []
  Decimal item_total_price    = 0

  #!!!!! NOTE The step definition "When I am at the Basket page" (that is used before this one for) is NOT located in this file (it's in remove_from_basket_steps.rb) !!!!!#

  #################################################     "BASKET PAGE"   ############################################################
  ##################################################################################################################################
  # The 'basket_page_data' hash is used to store the data that the Telium tag javascript data must be compared against.
  # 'basket_page_data' is to be filled with the appropriate values from the scenario data table and the current web page.
  ##################################################################################################################################
  @page_type = PAGE_TYPE['Basket']
  basket_page_data = @basketPage.get_core_page_data(@customer_email_address, @page_type)

  ######################################################################################################################
  # Get the item id, item code, name, description, quantity, price and customisation prices for each item in the basket.
  # This data is stored in an array of hashes named 'basket_item_hashes'.
  ######################################################################################################################
  basket_item_hashes = @basketPage.get_all_basket_items
  if ENABLED_LOGGING
    puts "\nINFO: ######## basket_item_hashes --- these are the keys/values for each item in the basket ########"
    basket_item_hashes.each do |item_hash|
      puts "\nINFO: #### Item ID #{item_hash['item_id']} has Item Code #{item_hash['item_code']} ####"
      item_hash.each { |key,val| puts "\nINFO: #{key} => #{val}" }
    end
  end

  ######################################################################################################################
  # Format the item codes, names, prices and quantities into arrays. Then insert the arrays into the basket_page_data hash.
  ######################################################################################################################
  basket_item_hashes.each do |item_hash|
    item_codes.push(item_hash['item_code'])
    item_names.push(item_hash['name'])
    item_total_price = Decimal(item_hash['price']) + Decimal(item_hash['customisation_price'])
    item_prices.push(item_total_price.to_s)
    item_qtys.push(item_hash['qty'])
  end

  basket_page_data.merge!("product_sku" => item_codes)
  basket_page_data.merge!("product_name" => item_names)
  basket_page_data.merge!("product_unit_price" => item_prices)
  basket_page_data.merge!("product_quantity" => item_qtys)

  ##################################################################################################################################################################################
  # Get all of the Telium utag_data javascript variables and their values. These are returned from method 'get_utag_javascript_variables' in an array of hashes.
  ##################################################################################################################################################################################
  user_logged_in = TRUE
  utag_hash = @basketPage.get_utag_javascript_variables(user_logged_in, @page_type)


  ##################################################################################################################################################################################
  # IMPORTANT NOTE: If we're not being too strict on item name comparison, then remove any extra space characters from the utag_data item names.
  # Not removing these extra space characters HAS PREVIOUSLY caused test failure.
  ##################################################################################################################################################################################
  if (!PROPER_ITEM_NAME_COMPARISON)
    utag_hash["product_name"].each do |utag_item_name|
      words = utag_item_name.split ' '
      proper_name = ''
      words.each { |word| proper_name.concat(word).concat(' ') }
      proper_name.strip! if !proper_name.empty?
      proper_item_names.push(proper_name)
    end
    utag_hash.merge!("product_name" => proper_item_names)
  end

  #######################################################################################################################################################################################
  # Now for each key/value in the hash 'basket_page_data', compare the corresponding key/value in the hash 'utag_hash'. The data in 'utag_hash' is specified in the requirements for
  # the Telium tags (see Branch 1521 and Mark Kneale's email sent 27/07/13)
  #######################################################################################################################################################################################
  puts "\n\nINFO: utag_data hash gives the customer_id (before its removal) of '#{utag_hash["customer_id"][/^[\d]+$/]}'" if ENABLED_LOGGING
  utag_hash["customer_id"][/^[\d]+$/].should_not == nil    # cannot verify customer_id outside of the database so check it's a string that contains only digits
  utag_hash.delete("customer_id")   # remove customer_id so we can do a simple comparison between hashes basket_page_data and utag_hash

  # If the website country is Germany then remove 'product_name' from both order_confirm_page_data and utag_hash hashes (because the data from the Order Confirmation page
  # is in German language while the Telium tag data is always in English).
  if @country == DE
    basket_page_data.delete("product_name")
    utag_hash.delete("product_name")
  end

  if ENABLED_LOGGING
    puts "\n\nINFO: ######## 'basket_page_data' and 'utag_data' hash keys/values ########"
    utag_hash.each { |key,val| puts "\nINFO: basket_page_data '#{key}' => '#{basket_page_data[key]}' :  utag_hash '#{key}' => '#{utag_hash[key]}'" }
  end

  ############################ THE IMPORTANT PART!! ######################################
  # The comparison between basket_page_data and utag_hash hashes that passes/fails this test. #
  ########################################################################################
  utag_hash.each { |key, val| utag_hash[key].should == basket_page_data[key] }
end



###############################################################################################################################################################
###############################################################################################################################################################
#--------------------   Step definitions common to the following Scenarios:   --------------------------------------------------------------------------------#
##################       'Telium' Tags are present and correct within the Search Results page when I am logged in to my account     ###########################
################         'Telium' Tags are present and correct within the Search No Results page when I am logged in to my account  ###########################
###############################################################################################################################################################
When /^I enter the "(.*)" into the Search field and submit this query$/ do |text|
  # Perform the search using the text specified in the scenario table data.
  # This will either return either:-
  # (1) a results page object 'SearchResultsPage' instance (if there are matches)
  # (2) a no-results page object 'SearchNoResultsPage' instance (if there are no matches)
  @srchResultsPage = @accountPage.search_for_text(text)
end

Then /^the Search Results page is displayed with matches for "(.*)"$/ do |text|
  ###########     Step for  "SEARCH RESULTS PAGE"    #########
  @page_type = PAGE_TYPE['Search']
  @search_text = text.sub(' ','+')            # if search criteria contains spaces then replace them with '+' characters
  url_text = text.sub(' ','%20')       # if search criteria contains spaces then replace them with '%20' to match that in the browser URL
  fail "ERROR: '#{text}' is not included in the search criteria. Browser URL is #{@browser.url}" if !@browser.url.downcase.include? url_text

  # Check there are some search results
  fail "ERROR: Check the Scenario data table. No search results are displayed for the search criteria #{text}" if @srchResultsPage.get_top_row_result_items.empty?
end

Then /^the Search No Results page is displayed with no matches for "(.*)"$/ do |text|
  ###########     Step for  "SEARCH NO RESULTS PAGE"    #########
  @page_type = PAGE_TYPE['SearchNoResult']
  @search_text = text.sub(' ','+')            # if search criteria contains spaces then replace them with with '+' characters
  url_text = text.sub(' ','%20')       # if search criteria contains spaces then replace them with '%20' to match that in the browser URL
  fail "ERROR: '#{text}' is not included in the search criteria. Browser URL is #{@browser.url}" if !@browser.url.downcase.include? url_text

  # Check there are no search results
  result = @srchResultsPage.found_result_items
  fail "ERROR: Check the Scenario data table. Search results should NOT be displayed for the search criteria #{text}" if result
end

And /^the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source, campaign_url_code, product_sku and site_search_keyword tags are present and have the expected values$/ do
  ################################################     "SEARCH RESULTS PAGE"    ####################################################
  ##################################################################################################################################
  # The 'search_no_results_page' hash is used to store the data that the Telium tag javascript data must be compared against.
  # 'search_no_results_page' is to be filled with the appropriate values from the scenario data table and the current web page.
  ##################################################################################################################################
  product_listing_page_data = @srchResultsPage.get_core_page_data(@customer_email_address, @page_type)
  top_row_product_items = @srchResultsPage.get_top_row_result_items
  product_listing_page_data.merge!("product_sku" => top_row_product_items)
  product_listing_page_data.merge!("site_search_keyword" => @search_text)

  # Read the Telium javascript data into the hash 'utag_hash'
  user_logged_in = TRUE
  utag_hash = @srchResultsPage.get_utag_javascript_variables(user_logged_in, @page_type)

  # The first part of the comparison between the page's data (for this scenario) and utag_hash that passes/fails this test.
  puts "\n\nINFO: utag_data hash gives the customer_id (before its removal) of '#{utag_hash["customer_id"][/^[\d]+$/]}'" if ENABLED_LOGGING
  utag_hash["customer_id"][/^[\d]+$/].should_not == nil                 # cannot verify customer_id outside of the database so check it's a string that contains only digits
  utag_hash.delete("customer_id")                                       # remove customer_id so we can do a simple comparison between hashes basket_page_data and utag_hash

  # The comparison between this page's data (for this Scenario) and utag_hash that passes/fails this test.
  if ENABLED_LOGGING
    puts "\n\nINFO: ######## 'product_listing_page_data' and 'utag_data' hash keys/values ########"
    utag_hash.each { |key,val| puts "\nINFO: product_listing_page_data '#{key}' => '#{product_listing_page_data[key]}' :  utag_hash '#{key}' => '#{utag_hash[key]}'" }
  end
  utag_hash.each { |key, val| utag_hash[key].should == product_listing_page_data[key] }
end

And /^the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source, campaign_url_code and site_search_keyword tags are present and have the expected values$/ do
  #############################################     "SEARCH NO RESULTS PAGE"    ####################################################
  ##################################################################################################################################
  # The 'search_no_results_page' hash is used to store the data that the Telium tag javascript data must be compared against.
  # 'search_no_results_page' is to be filled with the appropriate values from the scenario data table and the current web page.
  ##################################################################################################################################
  search_no_results_page = @srchResultsPage.get_core_page_data(@customer_email_address, @page_type)
  search_no_results_page.merge!("site_search_keyword" => @search_text)

  # Read the Telium javascript data into the hash 'utag_hash'
  user_logged_in = TRUE
  utag_hash = @srchResultsPage.get_utag_javascript_variables(user_logged_in, @page_type)

  # The first part of the comparison between the page's data (for this scenario) and utag_hash that passes/fails this test.
  puts "\n\nINFO: utag_data hash gives the customer_id (before its removal) of '#{utag_hash["customer_id"][/^[\d]+$/]}'" if ENABLED_LOGGING
  utag_hash["customer_id"][/^[\d]+$/].should_not == nil                 # cannot verify customer_id outside of the database so check it's a string that contains only digits
  utag_hash.delete("customer_id")                                       # remove customer_id so we can do a simple comparison between hashes basket_page_data and utag_hash

  # The comparison between this page's data (for this Scenario) and utag_hash that passes/fails this test.
  if ENABLED_LOGGING
    puts "\n\nINFO: ######## 'search_no_results_page' and 'utag_data' hash keys/values ########"
    utag_hash.each { |key,val| puts "\nINFO: search_no_results_page '#{key}' => '#{search_no_results_page[key]}' :  utag_hash '#{key}' => '#{utag_hash[key]}'" }
  end
  utag_hash.each { |key, val| utag_hash[key].should == search_no_results_page[key] }
end



#######################################################################################################################################################################################
#######################################################################################################################################################################################
#############     Step Definitions for Scenario: 'Telium' Tags are present within the ORDER CONFIRMATION PAGE when I am logged in, and have items in my basket       ##################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
When /^I am at the Order Confirmation page$/ do
  proper_item_names           = []
  @order_confirm_page_data    = {}
  total_item_count            = 0
  total_qty_count             = 0
  payment_attempts            = 0
  Decimal item_total_price    = 0

  # We are still on the Product page, so select 'checkout'.
  @basketPage = @detailPage.visit_checkout(@country)

  # Wait until the elements containing information about the basket items load
  @basketPage.wait_until_element_present(@basketPage.first_product_item_fieldset)

  # Click the 'secure checkout' button to start the Checkout process
  @deliveryPage = @basketPage.proceed_to_secure_checkout

  # Proceed with the payment process
  @paymentPage = @deliveryPage.continue_to_payment_page
  SUBMIT_VISA_PAYMENT_REPETITIONS.times do
    payment_status = @paymentPage.pay_by_visa
    payment_attempts+=1
    if payment_status == PAYMENT_NOT_ACCEPTED
      # This return value mans that the payment has been rejected (usually this happens 3 times before it's accepted when we use invalid card details)
      puts "\nINFO: VISA payment rejected on attempt no. #{payment_attempts}"
      # Fail this test if the payment for the order is rejected after 'SUBMIT_VISA_PAYMENT_REPETITIONS' attempts
      fail "ERROR: Payment for order unaccepted as it was rejected after #{payment_attempts} attempts" if payment_attempts == SUBMIT_VISA_PAYMENT_REPETITIONS
    else
      # A new instance of the page object 'OrderConfirmationPage' is returned (because the payment was successful this time)
      @orderConfirmPage = payment_status
    end
  end

  # Verify that the header from the Order Confirmation page is displayed. It contains the message:-
  # "Thank you, your order is placed and awaiting despatch.You will shortly receive an email confirming your order"
  @orderConfirmPage.confirmation_message_header_is_present.should == TRUE

  # Set the Page type to 'OrderConfirmed'
  @page_type = PAGE_TYPE['OrderConfirmed']

  ##################################################################################################################################
  # The 'order_confirm_page' hash is used to store the data that the Telium tag javascript data must be compared against.
  # 'order_confirm_page' is to be filled with the appropriate values from the scenario data table and the Order Confirmation page.
  ##################################################################################################################################
  @order_confirm_page_data.merge!("site_currency" => COUNTRY_CURRENCY[@country])
  @order_confirm_page_data.merge!("site_region" => @country)
  @order_confirm_page_data.merge!("page_name" => PAGE_TYPE.key(@page_type))
  @order_confirm_page_data.merge!("page_type" => @page_type.to_s)
  @order_confirm_page_data.merge!("customer_email" => @customer_email_address) if !@customer_email_address.empty?
  @order_confirm_page_data.merge!("customer_type" => 'D')   # is 'D' correct for every customer, is -1 a valid value?

  # Campaign Source depends on Country code.
  if @country == GB
    @order_confirm_page_data.merge!("campaign_source" => "UK+DIRECT+LOAD")
  else
    @order_confirm_page_data.merge!("campaign_source" => @country + "+DIRECT+LOAD")
  end

  # Find Campaign Code from the browser url (eg. 'gbpdefault' for GB)
  case @country
    when AU
      @campaign_url_code = "auddefault"
    when US
      @campaign_url_code = "usddefault"
    when DE
      @campaign_url_code = "dmdefault"
    when GB
      @campaign_url_code = "gbpdefault"
    else
      fail "ERROR: Country has not been specified. Test Results will be unreliable, so fail this test"
  end
  @order_confirm_page_data.merge!("campaign_url_code" => @campaign_url_code)

  ##################################################################################################################################
  # Get all the necessary data from the Order Confirmation page, so that a comparison can be made with the data in the 'utag_hash'
  # (see Mark K's email for a list of which parameters are verified)
  ##################################################################################################################################

  # Get the product item codes, names, prices and quantities for the contents of order. Then insert the arrays into the @order_confirm_page_data hash.
  format_for_telium_tests = TRUE
  order_product_details = @orderConfirmPage.get_order_product_details(format_for_telium_tests)

  # Get the subtotal, total and delivery prices for the contents of order. Then insert the arrays into the @order_confirm_page_data hash.
  order_totals = @orderConfirmPage.get_order_totals

  @order_confirm_page_data.merge!("product_sku" => order_product_details['item_codes'])
  @order_confirm_page_data.merge!("product_name" => order_product_details['product_names'])
  @order_confirm_page_data.merge!("order_shipping_amount" => order_totals['delivery'])
  @order_confirm_page_data.merge!("order_subtotal" => order_totals['subtotal'])
  @order_confirm_page_data.merge!("order_total" => order_totals['total'])
  @order_confirm_page_data.merge!("order_id" => @orderConfirmPage.order_reference_number)
  @order_confirm_page_data.merge!("order_shipping_type" => "S")                                       # 'S' is standard delivery
  @order_confirm_page_data.merge!("product_unit_price" => order_product_details['product_prices'])
  @order_confirm_page_data.merge!("product_quantity" => order_product_details['product_qtys'])
  order_product_details['product_qtys'].each { |qty| total_qty_count+=qty.to_i}
  @order_confirm_page_data.merge!("product_units" => total_qty_count)                                # no. of items in order
  @order_confirm_page_data.merge!("esearchvision_count" => '1')                          # always '1' (inherited from 'tagman')
  @order_confirm_page_data.merge!("esearchvision_Basket_Items" => total_qty_count)                    # no. of items in order
  @order_confirm_page_data.merge!("esearchvision_event" => "Purchase")                                # always 'Purchase'
end

Then /^the site_currency, site_region, page_name, page_type, customer_id, customer_email, customer_type, campaign_source, campaign_url_code, product_sku, product_name, order_shipping_amount, order_subtotal, order_btotal, order_id, order_shipping_type, product_unit_price and product_quantity and product_units tags are present and have the expected values$/ do
  #############################################     "ORDER CONFIRMATION PAGE"    ####################################################
  # Read the Telium javascript data into the hash 'utag_hash'
  user_logged_in = TRUE
  proper_item_names = []
  utag_hash = @orderConfirmPage.get_utag_javascript_variables(user_logged_in, @page_type)

  ##################################################################################################################################################################################
  # IMPORTANT NOTE: If we're not being too strict on item name comparison, then remove any extra space characters from the utag_data item names.
  # Not removing these extra space characters HAS PREVIOUSLY caused test failure.
  ##################################################################################################################################################################################
  if (!PROPER_ITEM_NAME_COMPARISON)
    utag_hash["product_name"].each do |utag_item_name|
      words = utag_item_name.split ' '
      proper_name = ''
      words.each { |word| proper_name.concat(word).concat(' ') }
      proper_name.strip! if !proper_name.empty?
      proper_item_names.push(proper_name)
    end
    utag_hash.merge!("product_name" => proper_item_names)
  end

  # The first part of the comparison between the page's data (for this scenario) and utag_hash that passes/fails this test.
  puts "\n\nINFO: utag_data hash gives the customer_id (before its removal) of '#{utag_hash["customer_id"][/^[\d]+$/]}'" if ENABLED_LOGGING
  utag_hash["customer_id"][/^[\d]+$/].should_not == nil                 # cannot verify customer_id outside of the database so check it's a string that contains only digits
  utag_hash.delete("customer_id")                                       # remove customer_id so we can do a simple comparison between hashes basket_page_data and utag_hash

  # If the website country is Germany then remove 'product_name' from both order_confirm_page_data and utag_hash hashes (because the data from the Order Confirmation page
  # is in German language while the Telium tag data is always in English).
  if @country == DE
    @order_confirm_page_data.delete("product_name")
    utag_hash.delete("product_name")
  end

  if ENABLED_LOGGING
    puts "\n\nINFO: ######## 'order_confirm_page_data' and 'utag_data' hash keys/values ########"
    @order_confirm_page_data.each { |key,val| puts "\nINFO: order_confirm_page_data '#{key}' => '#{@order_confirm_page_data[key]}' :  utag_hash '#{key}' => '#{utag_hash[key]}'" }
  end

  # The main comparison between this page's data (for this Scenario) and utag_hash that passes/fails this test.
  @order_confirm_page_data.each { |key, val| utag_hash[key].should == @order_confirm_page_data[key] }
end
