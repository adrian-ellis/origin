########################################################################################################################
#################     Scenario: verify casual shirt sizes are displayed      ###########################################
########################################################################################################################
Given /^I am on the product item detail page for casual shirt "(.*?)"$/ do |product_item_code|
  # Use the product search facility at the top of the page to load the detail page for the specified casual shirt (provided in the scenario data table)
  @detailPage = @homePage.search_for_casual_shirt(product_item_code)
end

When /^I select Size$/ do
  # wait until the Size selection box is loaded then open it
  @detailPage.open_shirt_size_select_box
end

Then /^several options are available for Size$/ do
  # Find the contents of the 'Size' selection box.
  @casual_shirt_sizes = @detailPage.find_all_shirt_sizes
  puts "\nINFO: Shirt sizes displayed: #{@casual_shirt_sizes}"
end

########################################################################################################################
#################     Scenario: verify casual shirt sizes can be selected      #########################################
########################################################################################################################
And /^select each one of the options in turn terminating with "(.*?)"$/ do |final_option|
  # wait until the shirt 'Size' links on this page load. Then select each link in turn to verify they can be selected.
  # Note that unavailable sizes (where the link text is an empty string) are skipped
  SOLD_OUT = "sold out"
  ON_ORDER = "on order"
  STOCK_DUE = "stock due"
  DEFAULT_SIZES = ["S","M","L","XL","XXL"]
  shirt_sizes = @detailPage.find_all_shirt_sizes

  fail "\nERROR: Cannot select any shirt sizes, as NONE are available to buy. Please use different shirt item in the scenario data table" if shirt_sizes.empty?
  shirt_sizes.each do |size_selection|
    result = @detailPage.set_shirt_size_value(size_selection)
    fail "ERROR: Cannot select Size value \'#{size_selection}\'" if !result

    # Verify that the selection box contains the value selected
    select_box_value = @detailPage.shirt_size_select_box_value
    fail "ERROR: Cannot select Size value \'#{size_selection}\'. Box still contains \'#{select_box_value}\'" if select_box_value != size_selection
    puts "\nINFO: Selected size \'#{select_box_value}\'"
    @detailPage.open_shirt_size_select_box
  end

  # finally select the 'Size' (link) specified in the scenario data table.
  @final_option_unavailable = FALSE
  if shirt_sizes.include? final_option
    @detailPage.set_shirt_size_value(final_option)
  else
    # if the final option specified in the scenario is unavailable, then select the first available size (from the selection box)
    @final_option_unavailable = TRUE
    @first_option = shirt_sizes.first
    puts "\nINFO: Cannot select \'#{final_option}\' as final size, so selecting \'#{@first_option}\' instead"
    @detailPage.set_shirt_size_value(@first_option)
  end

end

And /^I Add To Basket$/ do
  # Add the shirt to the basket
  @detailPage.add_to_basket
  fail "ERROR: Cannot add to basket\n" if @detailPage.sleeve_length_highlighted_in_red
end

And /^I navigate to the Checkout$/ do
  @basketPage = @detailPage.visit_checkout(@country)
  wait_until_element_present { @page.has_selector?('body#basket') }
end

Then /^the final option "(.*?)" is displayed in the item summary for "(.*?)"$/ do |final_option, target_item_code|
  target_item_id = ""
  all_data_item_ids = []
  #######################################################################################################################################################
  # iterate through fieldset block that is the root of the structure containing the item information,to so we may find the 'data-item-id' for each item 
  #######################################################################################################################################################
  wait_until_element_present { @basketPage.first_product_item_fieldset }
  #@basketPage.wait_until_element_present(@basketPage.first_product_item_fieldset)
  @basketPage.product_item_fieldsets.each do |item|
    # get item code from image link
    item_codes_from_url = item.find(:link_class, "img")['href'].split "|"
    item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

    # get data-item-id (that is used as a key to locate each item in the basket)
    id_attribute = item['id']
    data_item_id = id_attribute.sub(FIELDSET_PRODUCT_ITEM_SUFFIX,'')

	  # store data-item-id in an array (that we can use later to retrieve information relating to each item)
	  all_data_item_ids.push(data_item_id)

    # locate the target item for which the description is needed, by using its item code
	  target_item_id = data_item_id if (item_product_code == target_item_code)
  end

  #######################################################################################################################################################
  # iterate through basket items using the data-item-id (which uniquely identify each item in the basket) to find item code and item description.
  # Do this in reverse order so that the last item added is selected first. This is a precaution against picking up an item with the same item code
  # that was previously added to the basket (ie. in another scenario or another iteration of this scenario)
  #######################################################################################################################################################

  # Note that the final option specified in the scenario is unavailable, so this is why the FIRST_AVAILABLE_SIZE size available (from the selection box) was selected instead
  final_option = @first_option if @final_option_unavailable

  all_data_item_ids.reverse.each do |item_id|
    # get item code
    item_codes_from_url = @basketPage.item_image_link(item_id)['href'].split "|"
    item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

    # get item description
    item_size = @basketPage.product_item_description(item_id).text
    puts "\nINFO: item-id = #{item_id} : item_product_code = #{item_product_code} : size = #{item_size}" if ENABLED_LOGGING

    # item 'Size' (which is the only info that is stored in the item description) should match the value in scenario data table
    if item_id == target_item_id && item_size != final_option
      fail "ERROR: Item \'#{item_product_code}\' (with item-id \'#{item_id}\') has an incorrect size of \'#{item_size}\'"
      item_size.should == final_option
      break
    end
  end
end

########################################################################################################################
###################     Scenario: verify formal/evening shirt sizing options are displayed      ########################
########################################################################################################################
And /^I am on the product item detail page for a "(.*?)" with item code "(.*?)"$/ do |product_type, product_item_code|
  # Load the formal shirt product page and select a Collar Size in order to display the first page of shirts
  @slv_table_values = {}

  # Use the product search facility at the top of the page to load the detail page for the specified formal shirt (provided in the scenario data table)
  @detailPage = @homePage.search_for_formal_shirt(product_item_code)
end

When /^I select "(\w+\s\w+)"$/ do |size_option|
  # wait until the selection box is loaded then open it
  if size_option.downcase == "collar size"
    @detailPage.open_collar_size_select_box
  elsif size_option.downcase == "sleeve length"
    @detailPage.open_sleeve_length_select_box
    ###############################################################################################################################################
    # Create hash @slv_table_values where the 'key' is the actual length in inches, and 'val' is the code needed to select the
    # link within the 'div' table. The reason
    ###############################################################################################################################################
    @slv_table_values = @detailPage.get_all_sleeve_lengths
    puts "SLV LNS = #{@slv_table_values}\n"
  else
    puts "\nERROR: Invalid measurement option. Please use \'collar size\' or \'sleeve length\' instead"
  end
end

Then /^several options are available for "(.*?)"$/ do |size_option|
  # Find the contents of the 'Size' selection box (these are actually links under a 'div' with an 'id' of "shoe_size"!)
  if size_option.downcase == "collar size"
    @detailPage.all_collar_size_links.each do |link|
	    col_value = link.text
      puts "\nINFO: Collar size available includes #{col_value}"
    end
  elsif size_option.downcase == "sleeve length"
    # @slv_table_values hash contains all sleeve lengths (from last step)
    puts "\nINFO: Sleeve length available: #{@slv_table_values}"
  end
end


########################################################################################################################
###################  Scenario:  verify formal/evening shirt sizing options can be selected and the final values   ######
###################                before adding to basket are the values that are saved                          ######
########################################################################################################################
And /^choose the option "(.*?)" from "(.*?)"$/ do |size_option_value, size_option|
  if size_option.downcase == "collar size"
    puts "ABOUT TO SET COLLAR SIZE to #{size_option_value}\n"
    @detailPage.set_collar_size_value(size_option_value)
  elsif size_option.downcase == "sleeve length"
    @custom_sleeve = FALSE # default value
    size_option_code = @slv_table_values[size_option_value.to_s]
    # Determine if the sleeve length selected is a custom sleeve length. Note that the sleeve length selection box must be open first.
    puts "ABOUT TO SET SLEEVE LENGTH to #{size_option_code}: BOX OPEN IS OPEN #{@detailPage.sleeve_length_box_is_open}\n"
    #@detailPage.open_sleeve_length_select_box
    @custom_sleeve = TRUE if @detailPage.is_a_custom_sleeve_length(size_option_code)
    @detailPage.set_sleeve_length_value(size_option_code)
  end
end

And /^select each one of the options for "(.*?)" in turn terminating with "(.*?)"$/ do |size_option_2, final_option|
  ################################################################################################################################
  # wait until the shirt 'Sleeve length' links on this page load. Then select each link in turn to verify they can be selected.
  ################################################################################################################################
  out_of_stock = FALSE
  @slv_table_values.each do |size_option, size_option_code|
    @detailPage.set_sleeve_length_value(size_option_code)

    # verify the value of sleeve length in the select box matches the value selected. Note they will not match if size is out of stock.
    select_box_value = @detailPage.sleeve_length_select_box_value
    fail "ERROR: Cannot find the element that contains the \'sleeve length\' select box value" if select_box_value == CONTENTS_NOT_FOUND

    # Verify that the current value of sleeve length in the select box matches the value selected (by method set_sleeve_length_value()).
    out_of_stock = TRUE if (select_box_value.downcase.include? "sold out") || (select_box_value.downcase.include? "order now") || (select_box_value.downcase.include? "stock due")
    if select_box_value != @slv_table_values.key(size_option_code) && !out_of_stock
      Expect(select_box_value == @slv_table_values.key(size_option_code))
    end
    puts "\nINFO: Sleeve length value \'#{select_box_value}\' selected successfully for product item"
	
	  # open selection box to allow its current value to be changed
    @detailPage.open_sleeve_length_select_box
  end

  #######################################################################################################################################################
  # Determine if the sleeve length selected is a custom sleeve length. Note in to to do this the sleeve length selection box MUST be open first.
  #######################################################################################################################################################
  final_option_code = @slv_table_values[final_option.to_s]
  @custom_sleeve = TRUE if @detailPage.is_a_custom_sleeve_length(final_option_code)

  ################################################################################################################################
  # Select the FINAL 'Sleeve length' (link) specified in the scenario data table.
  ################################################################################################################################
  fail "\nERROR: Sleeve length value provided in scenario data table cannot be found. Please provide a valid sleeve length" if !@slv_table_values.include? final_option.to_s
  @detailPage.set_sleeve_length_value(final_option_code)
  puts "\nINFO: Sleeve length value #{final_option} is the final selection successfully for this product item"
end

Then /^the option "(.*?)" and the final option "(.*?)" are displayed in the item summary for "(.*?)"$/ do |size_option_1_value, final_option, target_item_code|
  #######################################################################################################################################################
  # find the 'product code', 'item description' and 'data item id' for the item stored in the basket
  #######################################################################################################################################################
  wait_until_element_present { @basketPage.first_product_item_fieldset }

  # get item code from image link
  item_codes_from_url = @basketPage.first_product_item_fieldset.find(:link_class, "img")['href'].split "|"
  item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

  # get data-item-id (that is used as a key to locate each item in the basket)
  id_attribute = @basketPage.first_product_item_fieldset['id']
  item_id = id_attribute.sub(FIELDSET_PRODUCT_ITEM_SUFFIX,'')

  # get item description
  item_description = @basketPage.product_item_description(item_id).text
  puts "\nINFO: Description for product item \'#{item_product_code}\' added to basket is #{item_description}"

  ####################################################################################################################
  # Find the collar size and sleeve length within the item description in the basket.
	# Note custom sleeve length extends the item description on to a newline so it requires a different match expression.
	####################################################################################################################
   if @custom_sleeve == TRUE
     match_result = item_description.match /(.*)collar(.*)sleeve(.*)sleeve(.*)/
	   sleeve_in_desc = match_result[4].gsub(",","").sub('"','').strip
   else
	   match_result = item_description.match /(.*)collar(.*)sleeve/
	   sleeve_in_desc = match_result[2].gsub(",","").sub('"','').strip
   end
   collar_in_desc = match_result[1].sub('"','').strip
	
	 ####################################################################################################################
   # Collar size and sleeve length should match the values in scenario data table
	 ####################################################################################################################
   if collar_in_desc != size_option_1_value
     expect(collar_in_desc).to eql(size_option_1_value.to_s)
   elsif sleeve_in_desc != final_option
     expect(sleeve_in_desc).to eql(final_option.to_s)
   end
end


########################################################################################################################
########################################################################################################################
###############################     Scenario: customisation on formal shirts      ######################################
########################################################################################################################
########################################################################################################################
When /^I select the options "(.*?)", "(.*?)" and "(.*?)"$/ do |customisation_option_1, customisation_option_2, customisation_option_3|
  # constants used for validating the scenario table data (input) to this test
  SINGLE_CUFF = "single cuff"
  DOUBLE_CUFF = "double cuff"
  ADD_POCKET =  "add pocket"
  ADD_MONOGRAM = "add monogram"

  # constants used for validating the results of this test
  CUSTOM_SLEEVE_RESULT = "shorten sleeve"
  ADDED_MONOGRAM_RESULT = "monogram"
  ADDED_POCKET_RESULT = "added pocket"
  CUSTOM_SLEEVE_AMOUNT = "8.95"
  MONOGRAM_AMOUNT = "7.95"
  POCKET_AMOUNT = "6.95"
  INITIALS = "XBM"

  # default value for options
  @single_cuff = FALSE
  @double_cuff = TRUE
  @add_pocket = FALSE
  @add_monogram = FALSE

  @customisation_option = [customisation_option_1, customisation_option_2, customisation_option_3]
  @customisation_option.each do |option|
    if option.downcase == SINGLE_CUFF
      @single_cuff = TRUE; @double_cuff = FALSE
      @detailPage.select_single_cuff
    end
    if option.downcase == DOUBLE_CUFF
      @double_cuff = TRUE
      @detailPage.select_double_cuff
    end
    if option.downcase == ADD_POCKET
      @add_pocket = TRUE
      @detailPage.select_add_pocket
      Expect(@detailPage.add_pocket_is_checked)
    end
    if option.downcase == ADD_MONOGRAM
      @add_monogram = TRUE
      @detailPage.select_add_monogram
      wait_until_element_present { @detailPage.monogram_lightbox }
      @detailPage.select_roman_block_font
      @detailPage.select_colour_navy
      @detailPage.fill_in_initials_text_box(INITIALS)
      @detailPage.select_position_cuff_centre
      @detailPage.confirm_add_monogram
      Expect(@detailPage.add_monogram_is_checked)
    end
  end
end

Then /^the "(.*?)", "(.*?)" and "(.*?)" options and their prices are displayed in the item summary for "(.*?)"$/ do |customisation_option_1, customisation_option_2, customisation_option_3, target_item_code|
  item_customisations_hsh = {}; custom_amounts = []
  #######################################################################################################################################################
  # find the 'product code', 'item description' and 'data item id' for the item stored in the basket
  #######################################################################################################################################################
  wait_until_element_present { @basketPage.first_product_item_fieldset }

  # get item code from image link
  item_codes_from_url = @basketPage.first_product_item_fieldset.find(:link_class, "img")['href'].split "|"
  item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

  # get data-item-id (that is used as a key to locate each item in the basket)
  id_attribute = @basketPage.first_product_item_fieldset['id']
  item_id = id_attribute.sub(FIELDSET_PRODUCT_ITEM_SUFFIX,'')

  # get item description
  item_description = @basketPage.product_item_description(item_id).text
  puts "\nINFO: Description for product item \'#{item_product_code}\' added to basket is #{item_description}"

  # Find the item's price
  item_price = @basketPage.item_price_amount(item_id)

  ####################################################################################################################
  # Find the item's customisation cost (remove '£' sign, which is the 1st character)
  ####################################################################################################################
  @basketPage.item_customisation_amounts(item_id).each do |amount|
    custom_amounts.push(amount.sub(/[^\d]/,"").strip)
  end

  ####################################################################################################################
  # Pair up the customisation option and its price. Store in the hash item_customisations_hsh.
  ####################################################################################################################
  index = 0
  @basketPage.item_customisation_types(item_id).each do |type|
    item_customisations_hsh.merge!({type => custom_amounts[index]})
    index+=1
  end
  puts "\nINFO: Customiations for \'#{item_product_code}\': #{item_customisations_hsh}"

	####################################################################################################################
  # Find the item's customisation options from the item's description
  # ( which has the format /(.*)sleeve(.*)\n(.*)\n?(.*)?\n?(.*)?/ maybe without the \n)
  ####################################################################################################################
  all_customisations = item_description[/(.*)sleeve,(.*)/,2]

  ####################################################################################################################
  # Verify that the customisation options match the values in the scenario data table
  ####################################################################################################################
  Expect(all_customisations.downcase.include? SINGLE_CUFF) if @single_cuff
  Expect(all_customisations.downcase.include? DOUBLE_CUFF) if @double_cuff
  Expect(all_customisations.downcase.include? 'added pocket') if @add_pocket
  Expect(all_customisations.downcase.include? 'shorten sleeve') if @custom_sleeve
  Expect(all_customisations.downcase.include? 'monogram') if @add_monogram

  ####################################################################################################################
  # Verify the cost of each customisation option is itemised and correct
  ####################################################################################################################
  expect(item_customisations_hsh.value_for_key_like('pocket')).to eql(POCKET_AMOUNT) if @add_pocket
  expect(item_customisations_hsh.value_for_key_like('sleeve')).to eql(CUSTOM_SLEEVE_AMOUNT) if @custom_sleeve
  expect(item_customisations_hsh.value_for_key_like('monogram')).to eql(MONOGRAM_AMOUNT) if @add_monogram
  Expect(item_price != nil)
end
