When /^I add "(.*)" of "(.*)", "(.*)" of "(.*)" and "(.*)" of "(.*)" items to my basket$/ do |qty_1,product_item_code_1,qty_2,product_item_code_2,qty_3,product_item_code_3|
  # Add all the product item codes (SKU's) and quantities to an array of hashes 'casual_shirt_items_and_qtys'
  casual_shirt_items_and_qtys = []
  casual_shirt_items_and_qtys.push({'qty' => qty_1, 'item_code' => product_item_code_1}) if !(product_item_code_1.empty? || qty_1.empty?)
  casual_shirt_items_and_qtys.push({'qty' => qty_2, 'item_code' => product_item_code_2}) if !(product_item_code_2.empty? || qty_2.empty?)
  casual_shirt_items_and_qtys.push({'qty' => qty_3, 'item_code' => product_item_code_3}) if !(product_item_code_3.empty? || qty_3.empty?)

  #############################################################################################################################################################
  # Remove all items from the basket if any are present. If we don't remove them (or clear the cookies that hold basket information), then this test will fail.
  #############################################################################################################################################################
  if @accountPage.get_number_of_items_in_basket != 0
    @basketPage = @accountPage.visit_checkout(@country)
    @basketPage.remove_all_items
    @page = @basketPage.navigate_to_home_page(@country)
  end

  if ENABLED_LOGGING
    puts "\nINFO: #################  DETAILS for Order to be placed for country '#{@country}' #################"
    puts "\nINFO: ##########   '#{qty_1}' of '#{product_item_code_1}',  '#{qty_2}' of '#{product_item_code_2}',  '#{qty_3}' of '#{product_item_code_3}'   ##########"
  end

  #############################################################################################################################################################
  # Add the items specified in the current row of the scenario data table to the basket.
  #############################################################################################################################################################
  casual_shirt_items_and_qtys.each do |item|
    # Use the product search facility at the top of the page to load the detail page for the specified casual shirt
    @detailPage = @page.search_for_casual_shirt(item['item_code'])

    # Open the 'size' selection box. Wait for it open, before selecting an option.
    @detailPage.open_shirt_size_select_box

    # Set the casual shirt size specified. If the size is not available (eg. as it's sold out) then just select the
    # first size available from the selection box (which is usually 'S').
    shirt_sizes = @detailPage.find_all_shirt_sizes
    size_selection = DEFAULT_SIZE
    size_selection = shirt_sizes.first if !shirt_sizes.include? DEFAULT_SIZE
    @detailPage.set_shirt_size_value(size_selection)

    # Note how many items are in the basket BEFORE the casual shirt is added.
    @qty_before = @detailPage.get_number_of_items_in_basket

    # Add casual shirt to basket
    @detailPage.quantity = item['qty']
    @detailPage.add_to_basket

    # Wait (default is up to PAGE_ELEMENT_TIMEOUT_SECS secs) until the item has been added to the basket
    time_secs = 0
    while time_secs < PAGE_ELEMENT_TIMEOUT_SECS
      break if @detailPage.get_number_of_items_in_basket > @qty_before
      sleep 1
      time_secs+=1
    end

    @page = @detailPage
  end
end

And /^I go through the checkout process$/ do
  payment_attempts = 0

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
end

Then /^the order details for "(.*)" of "(.*)", "(.*)" of "(.*)" and "(.*)" of "(.*)" are confirmed$/ do |qty_1,product_item_code_1,qty_2,product_item_code_2,qty_3,product_item_code_3|
  Decimal @dcml_total_of_item_prices  = 0
  casual_shirt_items_and_qtys         = []

  ##################################################################################################################################
  ##########  For the purposes of verifying the results of this test, format the product and quantity data for this scenario  ######
  ##################################################################################################################################
  # Take the item codes (SKU's) and quantities from the Scenario data table, and insert these into an array of hashes 'casual_shirt_items_and_qtys'
  casual_shirt_items_and_qtys.push({'qty' => qty_1, 'item_code' => product_item_code_1}) if !(product_item_code_1.empty? || qty_1.empty?)
  casual_shirt_items_and_qtys.push({'qty' => qty_2, 'item_code' => product_item_code_2}) if !(product_item_code_2.empty? || qty_2.empty?)
  casual_shirt_items_and_qtys.push({'qty' => qty_3, 'item_code' => product_item_code_3}) if !(product_item_code_3.empty? || qty_3.empty?)

  # We must sort the items into alphabetical order first, as this is how the Order Confirmation page lists the items.
  casual_shirt_items_and_qtys.sort_by! { |hash| hash['item_code']}
  no_of_item_codes = casual_shirt_items_and_qtys.length  # number of item codes (SKU's) in this row of the Scenario data table

  ##################################################################################################################################
  #######################        Get all the necessary data from the Order Confirmation page          ##############################
  ##################################################################################################################################

  #  Verify that the header from the Order Confirmation page is displayed. It contains the message:-
  # "Thank you, your order is placed and awaiting despatch.You will shortly receive an email confirming your order"
  @orderConfirmPage.confirmation_message_header_is_present.should == TRUE

  # Get the order reference number
  order_reference_number = @orderConfirmPage.order_reference_number

  # Get the product item codes, names, prices and quantities for the contents of order.
  # These are stored in an array of hashes 'order_product_details'. There is one hash for each item in the order.
  format_for_telium_tests = FALSE
  order_product_details = @orderConfirmPage.get_order_product_details(format_for_telium_tests)

  # Output the details for each item in the Order.
  if ENABLED_LOGGING
    puts "\nINFO: #########################  DETAILS of order '#{order_reference_number}' for country '#{@country}' on Order Confirmation page  #########################"
    order_product_details.each do |product|
      puts "\nINFO: item product code = '#{product['item_code']}' :  product name = '#{product['name']}' :  item quantity = '#{product['qty']}' :  item price = '#{product['price']}'"
    end
  end

  # Verify there is a valid order reference number (ie. not nil, as we have no way of knowing how it is generated)
  order_reference_number.should_not == nil

  ##################################################################################################################################
  #############     Verify the data from the Order Confirmation page matches data from the Scenario data table         #############
  ##################################################################################################################################
  for index in 0..(no_of_item_codes-1)

    ################################################################################################################################
    # Verify item codes (SKU's) are correct
    ################################################################################################################################
    order_product_details[index]['item_code'].should == casual_shirt_items_and_qtys[index]['item_code']

    ################################################################################################################################
    # Verify item quantities are correct
    ################################################################################################################################
    order_product_details[index]['qty'].should == casual_shirt_items_and_qtys[index]['qty']

    @dcml_total_of_item_prices = @dcml_total_of_item_prices + Decimal(order_product_details[index]['price'])
  end
end

And /^the subtotal, delivery and total amounts are correct$/ do
  Decimal dcml_delivery_amount        = 0
  Decimal dcml_basket_subtotal_amount = 0
  Decimal dcml_basket_total_amount    = 0

  #####################################################################################################################################################################################
  # Verify that the total we calculated by adding all the item's prices together (ie. the accumulated total amount) is equal to the subtotal displayed on the basket page
  #####################################################################################################################################################################################

  # Get the subtotal, total and delivery prices for the contents of order. These are stored in the hash 'order_totals',
  # which has keys 'subtotal', 'delivery' and 'total'
  order_totals = @orderConfirmPage.get_order_totals

  if ENABLED_LOGGING
    puts "\nINFO: SUBTOTAL = '#{order_totals['subtotal']}' :  DELIVERY = '#{order_totals['delivery']}' :  TOTAL = '#{order_totals['total']}'"
  end

  dcml_basket_subtotal_amount = Decimal(order_totals['subtotal'])
  if @dcml_total_of_item_prices != dcml_basket_subtotal_amount
    fail "ERROR: On the 'Order Confirmation' page the accumulated subtotal amount for Order '#{order_reference_number}' is '#{@dcml_total_of_item_prices}'. It does NOT EQUAL the subtotal '#{dcml_basket_subtotal_amount}' on the page"
  end

  # In the case of free delivery, check if delivery amount contains the word 'free' or 'frei' (in German language)
  free_delivery = TRUE if (order_totals['delivery'].downcase.include? 'free') || ((@country == DE) && (order_totals['delivery'].downcase.include? 'frei'))
  if !free_delivery
    # Fail the test if the delivery amount (excluding the first character) contains any non-digit characters excluding those used in currencies (typically ',' or '.').
    # This is because the delivery is not free, and we cannot be sure what the non-digit characters actually mean!
    del_str = order_totals['delivery'].sub(/./,'').sub(/,/,'').sub(/[^\d]/,'')
    fail "ERROR: Delivery amount #{delivery_amount} is not numeric so it cannot be added to the subtotal #{basket_subtotal_amount}" if del_str[/^[\d]+$/] == nil
  end

  #############################################################################################################################################################################
  # Finally, verify that the subtotal, total and delivery figures displayed on the Order Confirmation page are consistent with each other. The subtotal + delivery = total
  #############################################################################################################################################################################
  dcml_delivery_amount = Decimal(order_totals['delivery']) if !free_delivery
  dcml_basket_total_amount = Decimal(order_totals['total'])

  if dcml_basket_total_amount != dcml_basket_subtotal_amount + dcml_delivery_amount
    fail "ERROR: The total amount 'Order Confirmation' page is '#{dcml_basket_total_amount}'. It DOES NOT equal the subtotal '#{dcml_basket_subtotal_amount}' plus delivery '#{dcml_delivery_amount}'"
  end
end
