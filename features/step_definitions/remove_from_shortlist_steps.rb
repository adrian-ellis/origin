########################################################################################################################
###################     Scenario : Remove product item from the Maybe column in My Shortlist       #####################
########################################################################################################################
When /^I select Remove From Shortlist in the Shortlist 'Maybe Column' for item "(.*?)"$/ do |product_item_code_3|
  @target_item_id = ""

  # all_maybe_items returns a hash which stores all the item id's and item codes in the 'Maybe' column.
  # Copy this hash so we can use it for a comparison in the next 'step definition'.
  @shortListPage.wait_until_element_present(@shortListPage.first_maybe_item_id_root_div)
  @mbe_items = @shortListPage.all_maybe_items
  puts "\nBEFORE REMOVE: Item id\'s and Item Codes \'#{@mbe_items}\' are in the \'Maybe\' column"

  # Identify the item id of the item that has an item code of 'product_item_code_3' (from the scenario data table).
  @mbe_items.each do |key, val|
    @target_item_id = key if product_item_code_3 == val
  end
  @target_item_id.should_not == ""

  # Remove the target item from the 'Maybe' column.
  @shortListPage.remove_from_maybe_column(@target_item_id).click

  # Remove the target item from the hash that holds the contents of the 'Maybe' column BEFORE the target item is deleted from it.
  @mbe_items.delete(@target_item_id)
end

Then /^only the item "(.*?)" is removed from the Maybe Column$/ do |product_item_code_3|
  # verify item with the target item id has been removed from 'Maybe' column
  @shortListPage.wait_until_element_present(@shortListPage.first_maybe_item_id_root_div)
  @shortListPage.all_maybe_items.keys.should_not include @target_item_id

  # verify all the other items (apart from the target item) are still present in the 'Maybe' column
  puts "\nAFTER REMOVE: Item id\'s and Item Codes \'#{@shortListPage.all_maybe_items}\' are in the \'Maybe\' column"
  @mbe_items.sort.should == @shortListPage.all_maybe_items.sort
end


And /^the item "(.*?)" is added to the No Column$/ do |product_item_code_3|
  # Wait for the page to reload then verify the item with the target item id has been added to the 'No' column
  @shortListPage.wait_until_element_present(@shortListPage.first_no_item_id_root_div)
  @shortListPage.all_no_items.keys.should == [@target_item_id]
  @shortListPage.all_no_items[@target_item_id].should == product_item_code_3
  puts "\nAFTER REMOVE: Item id\'s and Item Codes \'#{@shortListPage.all_no_items}\' are in the \'No\' column"
end


########################################################################################################################
#################     Scenario : Remove all product items from the No column in My Shortlist       #####################
########################################################################################################################
And /^the items "(.*?)","(.*?)","(.*?)","(.*?)" and "(.*?)" are displayed in the Shortlist 'No' column$/ do |product_item_code_1,product_item_code_2,product_item_code_3,product_item_code_4,product_item_code_5|
  # Store the item codes in an array to make item code comparisons easier
  formal_shirts_added = [product_item_code_1, product_item_code_2, product_item_code_3, product_item_code_4, product_item_code_5]

  # navigate to the 'My Shortlist' page
  @shortListPage = @detailPage.click_view_all_items_button

  # all_maybe_items returns a hash which stores all the item id's and item codes in the 'Maybe' column.
  # Verify that the item codes match those from the scenario data table.
  @shortListPage.wait_until_element_present(@shortListPage.first_maybe_item_id_root_div)
  mbe_items = @shortListPage.all_maybe_items
  puts "\nBEFORE REMOVE from the \'Maybe\' column: Item id\'s and Item Codes \'#{mbe_items}\' are in the \'Maybe\' column"
  mbe_items.each do |key, val|
    formal_shirts_added.should include val
  end

  # Remove all the items from the 'Maybe' column.
  @shortListPage.all_maybe_items.each do |key, val|
    @shortListPage.remove_from_maybe_column(key).when_present.click
    sleep 1
  end
  puts "\nAFTER REMOVE from the \'Maybe\' column: Item id\'s and Item Codes \'#{@shortListPage.all_maybe_items}\' are in the \'Maybe\' column"

  # verify the items are now displayed in the 'No' column
  puts "\nAFTER REMOVE from the \'Maybe\' column: Item id\'s and Item Codes \'#{@shortListPage.all_no_items}\' are in the \'No\' column"
  @shortListPage.all_no_items.sort.should == mbe_items.sort
end

When /^I select Remove All from the No Column$/ do
  # Wait for the page to reload and then remove all items from the 'No' column
  @shortListPage.wait_until_element_present(@shortListPage.first_no_item_id_root_div)
  @shortListPage.remove_from_no_column.click
end

Then /^the items "(.*?)","(.*?)","(.*?)","(.*?)" and "(.*?)" are removed from the No Column$/ do |product_item_code_1, product_item_code_2, product_item_code_3, product_item_code_4, product_item_code_5|
  @shortListPage.wait_until_element_present(@shortListPage.no_column)
  puts "\nAFTER REMOVE from the \'No\' column: Item id\'s and Item Codes \'#{@shortListPage.all_no_items}\' are in the \'No\' column"

  # None of the 'div' elements, that contain all the other 'div's and 'links' related to Items in the 'No' column, should exist.
  @shortListPage.all_no_items.should == {}
end
