Given /^I am on the product item detail page for a suitable formal shirt "(.*?)"$/ do |product_item_code|
  # Load the formal shirt detail page for the item code provided in the scenario data table. Provide collar size.
  @detailPage = @homePage.search_for_formal_shirt(product_item_code)
  wait_until_element_present { @detailPage.main_controls_section }
end

When /^I select Add Monogram on the product item detail page$/ do
  wait_until_element_present { @detailPage.add_monogram_section }
  expect(@detailPage.find('add_mngm')) be(TRUE)
  @detailPage.select_add_monogram
end

Then /^the Add monogram lightbox appears$/ do
  wait_until_element_present { @detailPage.monogram_lightbox }
end

And /^the Add monogram lightbox contains selectable fields for font, colour and position and a text entry field for initials$/ do
  # check all objects in the lightbox are present (or just a few of them!)
	@detailPage.verify_all_colour_radio_buttons_present
	@detailPage.verify_all_font_radio_buttons_present
	@detailPage.verify_all_position_radio_buttons_present
end

And /^the Add Monogram button appears within the Add Monogram lightbox$/ do
  expect(@detailPage.add_monogram_checkbox_exists).to be(TRUE)
end

###########################################################################################################
#######    scenario : Add a monogram to a suitable (formal or evening) shirt displayed on the product page
###########################################################################################################
Given /^I am on the product item detail page for a formal shirt "(.*?)"$/ do |product_item_code|
  # Load the formal shirt detail page for the item code provided in the scenario data table. Provide collar size of 16 (as its a common size that should be in stock).
  @detailPage = @homePage.search_for_formal_shirt(product_item_code)
  wait_until_element_present { @detailPage.main_controls_section }
end

When /^I make a selection for "(.*?)", "(.*?)" and "(.*?)" and enter text into "(.*?)"$/ do |font, colour, position, initials|
  ############################################################
  # set the 'font' to the value specified in the scenario data
  ############################################################
	@detailPage.select_font(font.downcase)

  ##############################################################
  # set the 'colour' to the value specified in the scenario data
  ##############################################################
	@detailPage.select_colour(colour.downcase)

  ################################################################
  # set the 'initials' to the value specified in the scenario data
  ################################################################
  @detailPage.initials_text_box.set(initials)

  ################################################################
  # set the 'position' to the value specified in the scenario data
  ################################################################
	fail "\nERROR: \'position\' specified in scenario data table is invalid. It must be one of \'chest (left)\', \'cuff centre\', \'cuff above watch\' or \'cuff below link\'" if !['chest', 'cuff centre', 'cuff above watch', 'cuff below link'].include? position
	@detailPage.select_position(position.downcase)
end

And /^I click on the Add Monogram button$/ do
  @detailPage.confirm_add_monogram
end

Then /^the Add Monogram lightbox closes$/ do
  #@detailPage.monogram_lightbox.exists?.should == FALSE

end

And /^the product item detail page is still displayed$/ do
# CHECK PAGE ELEMENTS PRESENT
end

And /^the Add Monogram checkbox is checked$/ do
  expect(@detailPage.add_monogram_is_checked?).to be(TRUE)
end

And /^the monogram summary details for "(.*?)", "(.*?)", "(.*?)" and "(.*?)" are displayed next to the Add Monogram checkbox on the product item detail page$/ do |font, colour, position, initials|
  # The monogram text description eg. "You selected: brush script,black,\"AQA\",chest"
  # is delimited by commas so we split it into 4 parts, and then compensate for the \"<initials>\" component
  expect(@detailPage.monogram_description_is_displayed?).to be(TRUE)
  expect(@detailPage.monogram_description.empty?).to be(FALSE)
  monogram_desc = @detailPage.monogram_description.text.split ','
  monogram_desc.each { |desc| desc.strip! }

  # wrap "" around initials to match the monogram text description displayed on the web page
  initials_str = '"' + initials + '"'

  # now compare the monogram text description with the values from the scenario data table
  expect(font.downcase).to eq(monogram_desc[0].downcase.sub("you selected: ",''))  # remove "You selected:" from font
  expect(colour.downcase).to eq(monogram_desc[1].downcase)
  expect(initials_str.downcase).to eq(monogram_desc[2].downcase.gsub("\\",''))
  expect(position.downcase).to eq(monogram_desc[3].downcase)
end
