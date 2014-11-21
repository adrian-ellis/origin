#################################################################################################
# Steps for scenario : Cannot Add to basket when Mandatory clothing measurement/option is missing
#################################################################################################
Given /^I am on the "(.*?)" item detail page for "(.*?)"$/ do |product_type, product_item_code|
  case
    when product_type.downcase == "formal shirt"
      #############################################################################################
	    ############## FORMAL SHIRTS - Find shirt specified in scenario data table ##################
      #############################################################################################
      # Use the product search facility at the top of the page to load the detail page for the specified formal shirt (provided in the scenario data table)
      @detailPage = @homePage.search_for_formal_shirt(product_item_code)

      # wait until the product item detail page loads
      @item_code = product_item_code
      @product_type_formal_shirt = TRUE
    when product_type.downcase == "casual shirt"
      #############################################################################################
	    ############## CASUAL SHIRTS - Find shirt specified in scenario data table ##################
      #############################################################################################
      # Use the product search facility at the top of the page to load the detail page for the specified casual shirt (provided in the scenario data table)
      @detailPage = @homePage.search_for_casual_shirt(product_item_code)

      # wait until the product item detail page loads
      @item_code = product_item_code
      @product_type_casual_shirt = TRUE
    end
end

And /^the "(.*?)" selection box contains the text please select$/ do |mandatory_measurement|
  case
    when @product_type_formal_shirt == TRUE
	    # FORMAL SHIRTS - Verify sleeve length selection box contains 'please select'
	    if mandatory_measurement.downcase == "sleeve length"
        if @country != DE
          Expect(@detailPage.sleeve_length_select_box_value.downcase.include?(PROMPT_TO_SELECT_LANG_EN))
        else
          Expect(@detailPage.sleeve_length_select_box_value.downcase[PROMPT_TO_SELECT_LANG_DE] !=  nil)
        end
	    # FORMAL SHIRTS - Verify collar size selection box contains 'please select'
      elsif mandatory_measurement.downcase == "collar size"
      end	  
    when @product_type_casual_shirt == TRUE
	    # CASUAL SHIRTS - Verify collar size selection box contains 'please select'
	    if mandatory_measurement.downcase == "size"
        if @country != DE
          Expect(@detailPage.shirt_size_select_box_value.downcase.include?(PROMPT_TO_SELECT_LANG_EN))
        else
          Expect(@detailPage.shirt_size_select_box_value.downcase[PROMPT_TO_SELECT_LANG_DE] !=  nil)
        end
      end
  end
end

When /^I select Add To basket$/ do
  # add item to basket
  if @product_type_formal_shirt == TRUE || @product_type_casual_shirt == TRUE
    @before = @detailPage.get_number_of_items_in_basket
    @detailPage.add_to_basket
  end
end

Then /^the "(.*?)" selection box contains the text please select and is highlighted in red$/ do |mandatory_measurement|
  case
    when @product_type_formal_shirt == TRUE
	    # FORMAL SHIRTS - Verify sleeve length selection box contains 'please select' and is highlighted in red
	    if mandatory_measurement.downcase == "sleeve length"
        if @country != DE
          Expect(@detailPage.sleeve_length_select_box_value.downcase.include?(PROMPT_TO_SELECT_LANG_EN))
        else
          Expect(@detailPage.sleeve_length_select_box_value.downcase[PROMPT_TO_SELECT_LANG_DE] !=  nil)
        end
        Expect(@detailPage.sleeve_length_highlighted_in_red)
	    # FORMAL SHIRTS - Verify collar size selection box contains 'please select' and is highlighted in red
      elsif mandatory_measurement.downcase == "collar size"
      end
    when @product_type_casual_shirt == TRUE
	    # CASUAL SHIRTS - Verify size selection box contains 'please select' and is highlighted in red
	    if mandatory_measurement.downcase == "size"
        if @country != DE
          Expect(@detailPage.shirt_size_select_box_value.downcase.include?(PROMPT_TO_SELECT_LANG_EN))
        else
          Expect(@detailPage.shirt_size_select_box_value.downcase[PROMPT_TO_SELECT_LANG_DE] !=  nil)
        end
        Expect(@detailPage.size_highlighted_in_red)
      end
  end
end

And /^the clothing item is not added to my basket$/ do
  if @product_type_formal_shirt == TRUE || @product_type_casual_shirt == TRUE
    Expect(@detailPage.get_number_of_items_in_basket == @before)
  end
end

####################################################################################
# Steps for scenario : Can Add to basket when Mandatory clothing measurement/option is given
####################################################################################

And /^the "(.*?)" selection box already contains the text please select and is highlighted in red$/ do |mandatory_measurement|
  # add item to basket. this should cause the selection box in question to be highlighted in red
  if @product_type_formal_shirt == TRUE || @product_type_casual_shirt == TRUE
    @before = @detailPage.get_number_of_items_in_basket
    @detailPage.add_to_basket
    Expect(@detailPage.get_number_of_items_in_basket == @before)
  end

  case
    when @product_type_formal_shirt == TRUE
	    # FORMAL SHIRTS - Verify sleeve length selection box contains 'please select' and is highlighted in red
	    if mandatory_measurement.downcase == "sleeve length"
        if @country != DE
          Expect(@detailPage.sleeve_length_select_box_value.downcase.include?(PROMPT_TO_SELECT_LANG_EN))
        else
          Expect(@detailPage.sleeve_length_select_box_value.downcase[PROMPT_TO_SELECT_LANG_DE] !=  nil)
        end
        Expect(@detailPage.sleeve_length_highlighted_in_red)
	    # FORMAL SHIRTS - Verify collar size selection box contains 'please select' and is highlighted in red
      elsif mandatory_measurement.downcase == "collar size"
      end	  
    when @product_type_casual_shirt == TRUE
	    # CASUAL SHIRTS - Verify size selection box contains 'please select' and is highlighted in red
	    if mandatory_measurement.downcase == "size"
        if @country != DE
          Expect(@detailPage.shirt_size_select_box_value.downcase.include?(PROMPT_TO_SELECT_LANG_EN))
        else
          Expect(@detailPage.shirt_size_select_box_value.downcase[PROMPT_TO_SELECT_LANG_DE] !=  nil)
        end
        Expect(@detailPage.size_highlighted_in_red)
      end
  end
end

When /^I select a value from "(.*?)"$/ do |mandatory_measurement|
  small_size = "S"
  case
    when @product_type_formal_shirt == TRUE
	    # FORMAL SHIRTS - Select a value from the sleeve length selection box
	    if mandatory_measurement.downcase == "sleeve length"
        @detailPage.open_sleeve_length_select_box
        @detailPage.set_sleeve_length_by_index(3)
	    # FORMAL SHIRTS - Select a value from the collar size selection box
      elsif mandatory_measurement.downcase == "collar size"
        @detailPage.open_collar_size_select_box
        @detailPage.set_collar_size_by_index(3)
      elsif mandatory_measurement.downcase != ""
        puts "\nWARNING: Check the \'scenario\' data table for this \'feature\'. Formal shirt measurement for \'#{@item_code}\'is set to \'#{mandatory_measurement}\'. Only \'collar size\' or \'sleeve length\' are valid measurements"
	    end
    when @product_type_casual_shirt == TRUE
	    # CASUAL SHIRTS - Select a value from the size selection box
	    if mandatory_measurement.downcase == "size"
        @detailPage.open_shirt_size_select_box
        sleep 1
        result = @detailPage.set_shirt_size_value(small_size)
        if result == FALSE
          fail "\nERROR: Check the \'scenario\' data table for this \'feature\'. The \'#{mandatory_measurement}\' specified is either \'sold out\' or does not exist"
        end
      elsif mandatory_measurement.downcase != ""
        puts "\nWARNING: Check the \'scenario\' data table for this \'feature\'. Casual shirt measurement for \'#{@item_code}\'is set to \'#{mandatory_measurement}\'. Only \'size\' is a valid measurement"
      end
  end
end

Then /^the clothing item is added to my basket$/ do
  if @product_type_formal_shirt == TRUE || @product_type_casual_shirt == TRUE
    @after = @detailPage.get_number_of_items_in_basket
	  difference = @after - @before
	  expect(difference).to eql(1)
    sleep 2
  end
end

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################################################
# Mk 2 Version of the same feature
#####################################################################################################################################################################
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################################################
# FIRST SCENARIO
#####################################################################################################################################################################
And /^I do not select the mandatory option "([^\"]*?)" for a "([^\"]*?)"$/ do |option, item_type|
  # Make a factory to generate the item codes (instead of hard coding)
  formal_shirt_item_code = 'sn320bgo';  casual_shirt_item_code = 'cz096red'

  # Load up the item detail page for formal or casual shirt, but DO NOT select any mandatory option eg.size afterwards
  @item_type = item_type
  @option = option
  @detailPage = @homePage.search_for_formal_shirt(formal_shirt_item_code) if item_type == 'formal shirt'
  @detailPage = @homePage.search_for_casual_shirt(casual_shirt_item_code) if item_type == 'casual shirt'
end


When /^I select add to basket$/ do
  # get the number of items currently in the basket, before attempting to add item to basket
  @before = @detailPage.get_number_of_items_in_basket
  @detailPage.add_to_basket
end

Then /^the text "([^\"]*?)" is displayed in red$/ do |text|
  if @item_type == "formal shirt" && @option.downcase == "sleeve length"
    if @country != DE
      expect(@detailPage.sleeve_length_select_box_value.downcase).to eq(text)
    else
      expect(@detailPage.sleeve_length_select_box_value.downcase).to match(PROMPT_TO_SELECT_LANG_DE)
    end
    Expect(@detailPage.sleeve_length_highlighted_in_red)
  elsif @item_type == "casual shirt" && @option.downcase == "size"
    if @country != DE
      expect(@detailPage.shirt_size_select_box_value.downcase).to eq(text)
    else
      expect(@detailPage.shirt_size_select_box_value.downcase).to match(PROMPT_TO_SELECT_LANG_DE)
    end
    Expect(@detailPage.size_highlighted_in_red)
  end
end

And /^the item is not added to my basket$/ do
  expect(@detailPage.get_number_of_items_in_basket).to eql(@before)
end

#####################################################################################################################################################################
# SECOND SCENARIO
#####################################################################################################################################################################
And /^the text "([^\"]*?)" is displayed in red for mandatory option "([^\"]*?)" for the "([^\"]*?)"$/ do |text, option, item_type|
  # Make a factory to generate the item codes (instead of hard coding)
  formal_shirt_item_code = 'sn320bgo';  casual_shirt_item_code = 'cz096red'

  @detailPage = @homePage.search_for_formal_shirt(formal_shirt_item_code) if item_type == 'formal shirt'
  @detailPage = @homePage.search_for_casual_shirt(casual_shirt_item_code) if item_type == 'casual shirt'

  @before = @detailPage.get_number_of_items_in_basket
  @detailPage.add_to_basket

  if item_type == "formal shirt" && option.downcase == "sleeve length"
    if @country != DE
      expect(@detailPage.sleeve_length_select_box_value.downcase).to eq(text)
    else
      expect(@detailPage.sleeve_length_select_box_value.downcase).to match(PROMPT_TO_SELECT_LANG_DE)
    end
    Expect(@detailPage.sleeve_length_highlighted_in_red)
  elsif item_type == "casual shirt" && option.downcase == "size"
    if @country != DE
      expect(@detailPage.shirt_size_select_box_value.downcase).to eq(text)
    else
      expect(@detailPage.shirt_size_select_box_value.downcase).to match(PROMPT_TO_SELECT_LANG_DE)
    end
    Expect(@detailPage.size_highlighted_in_red)
  end
end

When /^I select the mandatory option "([^\"]*?)" for the "([^\"]*?)" item$/ do |option, item_type|
  small_size = 'S'
  index_value = 3

  if item_type == "formal shirt" && option.downcase == "sleeve length"
    @detailPage.open_sleeve_length_select_box
    @detailPage.set_sleeve_length_by_index(index_value)
  elsif item_type == "casual shirt" && option.downcase == "size"
    @detailPage.open_shirt_size_select_box
    sleep 1
    result = @detailPage.set_shirt_size_value(small_size)
    fail "\nERROR: Failed to select #{small_size} from the '#{option}' select box\n" if !result
  end
end

Then /^the item is added to my basket$/ do
  expect(@detailPage.get_number_of_items_in_basket).to eql(@before + 1)
  sleep 2
end

