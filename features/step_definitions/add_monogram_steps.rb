Given /^I am on the product item detail page for a suitable formal shirt "(.*?)"$/ do |product_item_code|
  # Load the formal shirt detail page for the item code provided in the scenario data table. Provide collar size.
  @detailPage = @page.search_for_formal_shirt(product_item_code)
  @detailPage.main_controls_section.wait_until_present
end

When /^I select Add Monogram on the product item detail page$/ do
  @detailPage.add_monogram_section.wait_until_present
  @detailPage.add_monogram_checkbox.exists?.should == TRUE
  @detailPage.add_monogram_checkbox.set
end

Then /^the Add monogram lightbox appears$/ do
  @detailPage.monogram_lightbox.wait_until_present
end

And /^the Add monogram lightbox contains selectable fields for font, colour and position and a text entry field for initials$/ do
  # check all objects in the lightbox are present (or just a few of them!)
  @detailPage.colour_black_radio_button.exists?.should == TRUE
  @detailPage.colour_burgundy_radio_button.exists?.should == TRUE
  @detailPage.initials_text_box.exists?.should == TRUE
  @detailPage.position_chest_radio_button.exists?.should == TRUE
end

And /^the Add Monogram button appears within the Add Monogram lightbox$/ do
  @detailPage.add_monogram_button.exists?.should == TRUE
end

###########################################################################################################
#######    scenario : Add a monogram to a suitable (formal or evening) shirt displayed on the product page
###########################################################################################################
Given /^I am on the product item detail page for a formal shirt "(.*?)"$/ do |product_item_code|
  # Load the formal shirt detail page for the item code provided in the scenario data table. Provide collar size of 16 (as its a common size that should be in stock).
  @detailPage = @page.search_for_formal_shirt(product_item_code)
  @detailPage.main_controls_section.wait_until_present
end

When /^I make a selection for "(.*?)", "(.*?)" and "(.*?)" and enter text into "(.*?)"$/ do |font, colour, position, initials|
  ############################################################
  # set the 'font' to the value specified in the scenario data
  ############################################################
  case
    when font.downcase == "brush script"
      @detailPage.select_brush_script_font
    when font.downcase == "circle"
      @detailPage.select_circle_font
    when font.downcase == "clarendon"
      @detailPage.select_clarendon_font
    when font.downcase == "diamond"
      @detailPage.select_diamond_font
    when font.downcase == "old english"
      @detailPage.select_old_english_font
    when font.downcase == "roman block"
      @detailPage.select_roman_block_font
    when font.downcase == "sports script"
      @detailPage.select_sports_script_font
    when font.downcase == "upright script"
      @detailPage.select_upright_script_font
    else
      fail "\nERROR: \'font\' specified in scenario data table is invalid"
  end

  ##############################################################
  # set the 'colour' to the value specified in the scenario data
  ##############################################################
  case
    when colour.downcase == "black"
      @detailPage.select_colour_black
    when colour.downcase == "burgundy"
      @detailPage.select_colour_burgundy
    when colour.downcase == "purple"
      @detailPage.select_colour_purple
    when colour.downcase == "navy"
      @detailPage.select_colour_navy
    when colour.downcase == "royal blue"
      @detailPage.select_colour_royal_blue
    when colour.downcase == "light blue"
      @detailPage.select_colour_light_blue
    when colour.downcase == "racing green"
      @detailPage.select_colour_racing_green
    when colour.downcase == "red"
      @detailPage.select_colour_red
    when colour.downcase == "pink"
      @detailPage.select_colour_pink
    when colour.downcase == "grey"
      @detailPage.select_colour_grey
    when colour.downcase == "yellow"
      @detailPage.select_colour_yellow
    when colour.downcase == "white"
      @detailPage.select_colour_white
    else
      fail "\nERROR: \'colour\' specified in scenario data table is invalid"
  end

  ################################################################
  # set the 'initials' to the value specified in the scenario data
  ################################################################
  @detailPage.initials_text_box.set(initials)

  ################################################################
  # set the 'position' to the value specified in the scenario data
  ################################################################
  case
    when position.downcase == "chest (left)"
      @detailPage.select_position_chest
    when position.downcase == "cuff centre"
      @detailPage.select_position_cuff_centre
    when position .downcase== "cuff above watch"
      @detailPage.select_position_cuff_above_watch
    when position.downcase == "cuff below link"
      @detailPage.select_position_cuff_below_link
    else
      fail "\nERROR: \'position\' specified in scenario data table is invalid. It must be one of \'chest (left)\', \'cuff centre\', \'cuff above watch\' or \'cuff below link\'"
  end
end

And /^I click on the Add Monogram button$/ do
  @detailPage.add_monogram_button.when_present.fire_event("onclick")
end

Then /^the Add Monogram lightbox closes$/ do
  #@detailPage.monogram_lightbox.exists?.should == FALSE

end

And /^the product item detail page is still displayed$/ do
# CHECK PAGE ELEMENTS PRESENT
end

And /^the Add Monogram checkbox is checked$/ do
  @detailPage.add_monogram_checkbox_value.should == "checked"
end

And /^the monogram summary details for "(.*?)", "(.*?)", "(.*?)" and "(.*?)" are displayed next to the Add Monogram checkbox on the product item detail page$/ do |font, colour, position, initials|
  # The monogram text description eg. "You selected: brush script,black,\"AQA\",chest"
  # is delimited by commas so we split it into 4 parts, and then compensate for the \"<initials>\" component
  @detailPage.monogram_description.when_present.exists?.should == TRUE
  @detailPage.monogram_description.when_present.text.should_not == ""
  monogram_desc = @detailPage.monogram_description.text.split ','
  monogram_desc.each { |desc| desc.strip! }

  # wrap "" around initials to match the monogram text description displayed on the web page
  initials_str = '"' + initials + '"'

  # now compare the monogram text description with the values from the scenario data table
  font.downcase.should == monogram_desc[0].downcase.sub("you selected: ",'')  # remove "You selected:" from font
  colour.downcase.should == monogram_desc[1].downcase
  initials_str.downcase.should == monogram_desc[2].downcase.gsub("\\",'')
  position.downcase.should == monogram_desc[3].downcase
end
