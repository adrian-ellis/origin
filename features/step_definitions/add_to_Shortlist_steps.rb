########################################################################################################################
########   Scenario : Verify Shortlist Minibar components are displayed when adding an item to the Shortlist   #########
########################################################################################################################
When /^I select Add To Shortlist$/ do
  @detailPage.add_to_shortlist.when_present.click
end

Then /^the Shortlist Minibar is displayed underneath the product item detail page$/ do
  # verify shortlist minibar is displayed
  @detailPage.wait_until_element_present(@detailPage.minibar)
  @detailPage.minibar_header.exists?.should == TRUE
end

And /^the item "(.*?)" is added to the Shortlist$/ do |product_item_code|
  # Wait for the text link on the minibar to load (this can be a problem as this part of the page is reloading which causes an error
  # 'StaleElementReferenceError: Element is no longer attached to the DOM') and the only way around it is to add a 'sleep' statement
  # and then try to locate it again.
  begin
    @detailPage.view_all_items_text_link.wait_until_present
  rescue Watir::Wait::TimeoutError
    p 'rescued from timeout'
  rescue Selenium::WebDriver::Error::ObsoleteElementError
    p 'rescued from ObsoleteElementError'
  rescue  Selenium::WebDriver::Error::StaleElementReferenceError
    p 'rescued from StaleElementReferenceError'
  end

  # verify no. of items in:
  # 1) the shortlist header itself
  # 2) the text link (located near the items in the shortlist bar)
  # are both "5" (as 5 items were added in the last step definition)
  text_link = @detailPage.view_all_items_text_link.text
  item_count_in_text_link = text_link[/(You have)\s(\d+)\s(items in your shortlist click here to view all items in detail)/, 2].to_i
  item_count_in_text_link.should == 1
  @detailPage.qty_in_shortlist.text.to_i.should == 1
end

And /^the correct thumbnail image for "(.*?)" is displayed in the Shortlist Minibar$/ do |product_item_code|
  @detailPage.shortlist_item_thumbnail_link(product_item_code).exists?.should == TRUE
  @detailPage.shortlist_item_thumbnail_photo(product_item_code).exists?.should == TRUE
end

And /^the View All Items In Detail, My Shortlist header, Information text link, Minimise Shortlist and Close Shortlist controls are displayed in the Shortlist Minibar$/ do
  # verify text link and button to the shortlist page are displayed
  @detailPage.view_all_items_button.exists?.should == TRUE
  @detailPage.view_all_items_button_image.exists?.should == TRUE
end

########################################################################################################################
######################     Scenario : Add multiple product items to the Shortlist       ################################
########################################################################################################################
And /^I add 5 "(.*?)" with item codes "(.*?)","(.*?)","(.*?)","(.*?)" and "(.*?)" to the Shortlist$/ do |product_type, product_item_code_1, product_item_code_2, product_item_code_3, product_item_code_4, product_item_code_5|
  # Load the formal shirt detail page for the item code provided in the scenario data table. Provide collar size.
  @formal_shirts = [product_item_code_1, product_item_code_2, product_item_code_3, product_item_code_4, product_item_code_5]

  qty_before = 0
  @formal_shirts.each do |product_item_code|
    # Use the product search facility at the top of the page to load the detail page for the specified formal shirt
    @detailPage = @page.search_for_formal_shirt(product_item_code)

    # Wait for the quantity link within the 'Shortlist' minibar to refresh if this is NOT the first shirt to be added to the 'Shortlist'
    if product_item_code != product_item_code_1
      wait_until_element_present(@detailPage.qty_in_shortlist)
      qty_before = @detailPage.qty_in_shortlist.text.to_i
    end

    # Add the formal shirt to the 'Shortlist'
    @detailPage.add_to_shortlist.when_present.click

    # Wait for the quantity link within the 'Shortlist' minibar to appear/refresh
    wait_until_element_present(@detailPage.qty_in_shortlist)

    # Verify the quantity in the shortlist minibar has updated
    @detailPage.qty_in_shortlist.text.to_i.should == qty_before + 1

    @page = @detailPage
  end
end


Then /^the items "(.*?)","(.*?)","(.*?)","(.*?)" and "(.*?)" are added to the Shortlist Minibar$/ do |product_item_code_1,product_item_code_2,product_item_code_3,product_item_code_4,product_item_code_5|
  # Wait for the text link on the minibar to load (this can be a problem as this part of the page is reloading which causes an error
  # 'StaleElementReferenceError: Element is no longer attached to the DOM') and the only way around it is to add a 'sleep' statement
#  retry_if_DOM_reference_lost(@detailPage.view_all_items_text_link) { @detailPage.view_all_items_text_link.exists? }

  # verify no. of items in:
  # 1) the shortlist header itself and
  # 2) the text link (by the items in the shortlist bar) are both "5" (as 5 items were added in the last step definition)
  text_link = @detailPage.view_all_items_text_link.text
  item_count_in_text_link = text_link[/(You have)\s(\d+)\s(items in your shortlist click here to view all items in detail)/, 2].to_i
  item_count_in_text_link.should == @formal_shirts.length
  @detailPage.qty_in_shortlist.text.to_i.should == @formal_shirts.length
end

And /^the correct thumbnail images for "(.*?)","(.*?)","(.*?)","(.*?)" and "(.*?)" are displayed in the Shortlist Minibar$/ do |product_item_code_1,product_item_code_2,product_item_code_3,product_item_code_4,product_item_code_5|
  @formal_shirts.each do |product_item_code|
    @detailPage.shortlist_item_thumbnail_link(product_item_code).exists?.should == TRUE
    @detailPage.shortlist_item_thumbnail_photo(product_item_code).exists?.should == TRUE
  end
end


########################################################################################################################
###############     Scenario : My Shortlist contains the product items in the Maybe column       #######################
########################################################################################################################
When /^I select View All Items In Detail$/ do
  @shortListPage = @detailPage.click_view_all_items_button
end

Then /^the My Shortlist page is displayed$/ do
  @shortListPage.wait_until_element_present(@shortListPage.header)
  @shortListPage.maybe_column.exists?.should == TRUE
  @shortListPage.yes_column.exists?.should == TRUE
  @shortListPage.no_column.exists?.should == TRUE
end

Then /^the items "(.*?)","(.*?)","(.*?)","(.*?)" and "(.*?)" are displayed in the Shortlist 'Maybe' column$/ do |product_item_code_1,product_item_code_2,product_item_code_3,product_item_code_4,product_item_code_5|
  formal_shirts_added = [product_item_code_1, product_item_code_2, product_item_code_3, product_item_code_4, product_item_code_5]

  # Find all the shortlist item id's in the 'Maybe' column.
  @shortListPage.wait_until_element_present(@shortListPage.first_maybe_item_id_root_div)
  @shortListPage.all_maybe_items.values.sort.should == formal_shirts_added.sort
end