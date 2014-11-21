Given /^I have the clothing items "(.*)", "(.*)" and "(.*)" in my basket$/ do |product_item_code_1, product_item_code_2, product_item_code_3|
  DEFAULT_SIZE = "L"
  FIRST = 0
  casual_shirt_product_item_codes = []
  #######################################################################################################################################################
  # FOR EACH CASUAL SHIRT SPECIFIED IN THE SCENARIO DATA TABLE, LOAD IT'S DETAIL PAGE AND THEN ADD IT TO THE BASKET
  #######################################################################################################################################################

  # Read the item codes from the scenario data table, and push these item codes into an array (if the item code exists)
  casual_shirt_product_item_codes.push(product_item_code_1) if product_item_code_1 != ""
  casual_shirt_product_item_codes.push(product_item_code_2) if product_item_code_2 != ""
  casual_shirt_product_item_codes.push(product_item_code_3) if product_item_code_3 != ""

  # Loop for each casual shirt whose product code is specified in this test
  casual_shirt_product_item_codes.each do |product_item_code|
    # Use the product search facility at the top of the page to load the detail page for the specified casual shirt
    @detailPage = @page.search_for_casual_shirt(product_item_code)

    # Open the 'size' selection box. Wait for it open, before selecting an option.
    @detailPage.open_shirt_size_select_box

    # Set the casual shirt size specified (DEFAULT_SIZE). If the size is not available (eg. as it's sold out) then just select the
    # first size available from the selection box (which is usually 'S').
    shirt_sizes = @detailPage.find_all_shirt_sizes
    size_selection = DEFAULT_SIZE
    size_selection = shirt_sizes[FIRST] if !shirt_sizes.include? DEFAULT_SIZE
    @detailPage.set_shirt_size_value(size_selection)

    # Add casual shirt to basket
    @detailPage.add_to_basket
    @homePage = @detailPage
  end
end

And /^I am at the Basket page$/ do
  # navigate to basket page
  @basketPage = @detailPage.visit_checkout(@country)
  @basketPage.url.should == BASKET_LINK_URL
  @basketPage.first_product_item_fieldset.wait_until_present
end


When /^I select Remove next to the clothing item "(.*)"$/ do |product_item_code_3|
  #######################################################################################################################################################
  # Store the price of the product items in the basket, the delivery cost amount, the subtotal grand total from this page etc as decimals.
  #######################################################################################################################################################
  Decimal @orig_delivery_amount = 0
  Decimal @orig_subtotal_amount = 0
  Decimal @orig_total_amount    = 0
  Decimal @target_item_price    = 0
  found_target_item             = FALSE

  #######################################################################################################################################################
  # Get the item id, item code, name, description, quantity and price for each item in the basket.
  #######################################################################################################################################################
  all_basket_items_hashes = @basketPage.get_all_basket_items
  all_basket_items_hashes.each do |item_hash|
    # log details for each item in the basket if needed
    puts "\nBEFORE: item-id = #{item_hash['item_id']} : item_product_code = #{item_hash['item_code']} : item_quantity = #{item_hash['qty']} : item_price = #{item_hash['price']}" if ENABLED_LOGGING

    #######################################################################################################################################################
    # locate the target item for which the quantity is updated, by using its item code
    #######################################################################################################################################################
    if (item_hash['item_code'] == product_item_code_3)
      @target_item_id = item_hash['item_id']
      @target_item_code = item_hash['item_code']
      @target_item_price = Decimal(item_hash['price'])
      found_target_item = TRUE
    end
  end
  fail "ERROR: Cannot find target item \'#{product_item_code_3}\' in the basket" if !found_target_item

  #######################################################################################################################################################
  # get the subtotal, delivery and total prices that are displayed on the basket page
  #######################################################################################################################################################
  basket_totals_hash = @basketPage.get_basket_totals
  @orig_subtotal_amount = Decimal(basket_totals_hash['subtotal'])
  @orig_delivery_amount = Decimal(basket_totals_hash['delivery'])
  @orig_total_amount    = Decimal(basket_totals_hash['total'])

  # log details for subtotal, delivery and total in the basket if needed
  puts "\nBEFORE: All Items Total = #{@orig_total_amount} : basket subtotal amount = #{@orig_subtotal_amount} : delivery amount = #{@orig_delivery_amount}}" if ENABLED_LOGGING

  #######################################################################################################################################################
  # Remove the 'target' item from the basket
  #######################################################################################################################################################
  @basketPage.remove_item(@target_item_id)

  # Wait for the basket page to refresh
  @basketPage.wait_until_basket_refreshes(@orig_subtotal_amount)
end

Then /^"(.*)" is removed from my basket$/ do |product_item_code_3|
  # confirm that the 'target' item has been removed from the basket
  fail "\nERROR: Item #{product_item_code_3} has not been deleted from basket" if @basketPage.product_item_fieldset(@target_item_id).exists? == TRUE
end

And /^the subtotal and grand total are updated to reflect the clothing item's removal$/ do
  # Get the item id, item code, name, description, quantity and price for each item in the basket.
  all_basket_items_hashes = @basketPage.get_all_basket_items
  all_basket_items_hashes.each do |item_hash|
    # log details for each item in the basket if needed
    puts "\nAFTER: item-id = #{item_hash['item_id']} : item_product_code = #{item_hash['item_code']} : item_quantity = #{item_hash['qty']} : item_price = #{item_hash['price']}" if ENABLED_LOGGING
  end

  # get the subtotal, delivery and total prices that are displayed on the basket page
  basket_totals_hash = @basketPage.get_basket_totals
  @new_subtotal_amount = Decimal(basket_totals_hash['subtotal'])
  @new_delivery_amount = Decimal(basket_totals_hash['delivery'])
  @new_total_amount    = Decimal(basket_totals_hash['total'])

  # log details for subtotal, delivery and total in the basket if needed
  puts "\nAFTER: All Items Total = #{@new_total_amount} : basket subtotal amount = #{@new_subtotal_amount} : delivery amount = #{@new_delivery_amount}}" if ENABLED_LOGGING

  #######################################################################################################################################################
  # If the delivery price has NOT changed as a result of removing the target item from the basket, then compare the totals before and after the removal
  #######################################################################################################################################################
  if @new_delivery_amount == @orig_delivery_amount
    if @target_item_price != (@orig_total_amount - @new_total_amount)
      puts "\nThe current total amount in the Basket \'#{@new_total_amount}\' plus the value of the item removed \'#{@target_item_price}\' does not equal the original total amount\'#{@orig_total_amount}\'"
      @target_item_price.should == (@orig_total_amount - @new_total_amount)
    end
  end
  #######################################################################################################################################################
  # Compare the subtotals before and after removing the target item from the basket
  #######################################################################################################################################################
  if @target_item_price != (@orig_subtotal_amount - @new_subtotal_amount)
    puts "\nThe current subtotal amount in the Basket \'#{@new_subtotal_amount}\' plus the value of the item removed \'#{@target_item_price}\' does not equal the original subtotal amount\'#{@orig_subtotal_amount}\'"
    @target_item_price.should == (@orig_subtotal_amount - @new_subtotal_amount)
  end
end