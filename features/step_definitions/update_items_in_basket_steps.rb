When /^I alter the quantity for clothing item "(.*)" from "(.*)" to "(.*)"$/ do |product_item_code_2, quantity ,updated_quantity|
  #######################################################################################################################################################
  # Store the price of the product items in the basket, the delivery cost amount, the subtotal grand total from this page etc as decimals.
  #######################################################################################################################################################
  Decimal @orig_delivery_amount = 0
  Decimal @orig_subtotal_amount = 0
  Decimal @orig_total_amount    = 0
  Decimal @target_item_price    = 0
  @orig_target_item_quantity    = 0
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
    if (item_hash['item_code'] == product_item_code_2)
      @target_item_id = item_hash['item_id']
      @target_item_code = item_hash['item_code']
      @orig_target_item_quantity = item_hash['qty']
      fail "ERROR: Before updating its quantity, target item \'#{product_item_code_2}\' has incorrect quantity of \'#{@orig_target_item_quantity}\'" if @orig_target_item_quantity != quantity
      @target_item_price = Decimal(item_hash['price'])
      found_target_item = TRUE
    end
  end
  fail "ERROR: Cannot find target item \'#{product_item_code_2}\' in the basket" if !found_target_item

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
  # Update the quantity for the 'target' item
  #######################################################################################################################################################
  @basketPage.set_item_quantity(@target_item_id, updated_quantity)
  @basketPage.item_update_quantity(@target_item_id)

  # Wait for the basket page to refresh
  @basketPage.wait_until_basket_refreshes(@orig_subtotal_amount)
end


Then /^the quantity for the clothing item "(.*)" in my basket is updated to "(.*)"$/ do |product_item_code_2, updated_quantity|
  #######################################################################################################################################################
  # Verify that the quantity for the 'target' item has changed to 'updated_quantity' (as specified in this scenario's data table)
  #######################################################################################################################################################
  found_target_item_id = FALSE
  all_basket_items_hashes = @basketPage.get_all_basket_items
  all_basket_items_hashes.each do |item_hash|
    if (item_hash['item_id'] == @target_item_id)
      found_target_item_id = TRUE
      fail "Item quantity \'#{item_hash['qty']}\' for \'#{product_item_code_2}\' is incorrect and should have changed to \'#{updated_quantity}\'" if item_hash['qty'] != updated_quantity
    end
  end
  fail "ERROR : Failed to find the item data id for the item whose \'quantity\' was changed. Test has failed" if found_target_item_id == FALSE
end


And /^the subtotal and grand total are updated to reflect this change$/ do
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
end


And /^the offer to buy a fifth shirt for "(.*?)" appears in a lightbox$/ do |amount|
  #-----------------------------------------------------------------
  ##################################################################
  # Verify fries popup appears and contains specified text and links
  ##################################################################
  #-----------------------------------------------------------------
  MAIN_PARAGRAPH_TEXT = "Limited offer! Buy a fifth shirt for only"
  LOWER_PARAGRAPH_TEXT = "If you would prefer to choose your extra shirt later, you can reactivate this offer by clicking on the link under your basket summary."
  OFFER_TEXT = "VIEW SHIRTS FOR"
  @time_secs = 0
  until @basketPage.fries_popup.exists? == TRUE
    @time_secs = @time_secs + 1
    break if @time_secs > 20
    sleep 1
  end

  puts "\nERROR: Fries popup didn\'t open even after a 20 second wait" if @time_secs > 20
  @basketPage.fries_popup.exists?.should == TRUE
  ##############################################################
  # fries popup contains paragraphs with specified text
  ##############################################################
  @basketPage.fries_main_paragraph.text.should include (MAIN_PARAGRAPH_TEXT)
  @basketPage.fries_lower_paragraph.text.should include(LOWER_PARAGRAPH_TEXT)
  @basketPage.fries_offer_link.text.should include(OFFER_TEXT)
  #####################################################
  # Verify the 'Fries' Offer amount is 25
  #####################################################
  match = @basketPage.fries_offer_link.text.match /(\d+)/
  match[1].should == amount

  #####################################################
  # close fries popup link is displayed
  #####################################################
  puts "\nERROR: Fries popup has no close link" if @basketPage.close_fries_link.exists? != TRUE
  @basketPage.close_fries_link.exists?.should == TRUE
end


And /^there is a link to view the shirts available in the lightbox$/ do
  #######################################################
  # fries popup has a link to view shirts in the offer
  #######################################################
  puts "\nERROR: Fries offer link not found" if @basketPage.fries_offer_link.exists? != TRUE
  @basketPage.fries_offer_link.exists?.should == TRUE
end
