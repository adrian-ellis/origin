Given /^I am on the product item detail page for a formal shirt "(.*?)"$/ do |product_item_code|
  # Load the formal shirt detail page for the item code provided in the scenario data table.
  @detailPage = @homePage.search_for_formal_shirt(product_item_code)
end

When /^I select Add Monogram on the product item detail page$/ do
  wait_until_element_present { @detailPage.add_monogram_section }
  expect(@detailPage.add_monogram_checkbox_displayed?).to be(TRUE)
  @detailPage.check_add_monogram
end

Then /^the Add monogram lightbox appears$/ do
  expect(@detailPage.monogram_lightbox_displayed?).to be(TRUE)
end

And /^the Add monogram lightbox contains selectable fields for font, colour and position and a text entry field for initials$/ do
  # check all the controls (objects) that we need to use within the lightbox are present
  ALL_MG_COLOURS.each do |c|
	  expect(@detailPage.colour_radio_button_present(c)).to be(TRUE)
  end

  ALL_MG_FONTS.each do |f|
    expect(@detailPage.font_radio_button_present(f)).to be(TRUE)
  end

  ALL_MG_POSITIONS.each do |p|
    expect(@detailPage.position_radio_button_present(p)).to be(TRUE)
  end
end

And /^the Add Monogram button appears within the Add Monogram lightbox$/ do
  expect(@detailPage.add_monogram_button_displayed?).to be(TRUE)
end

###########################################################################################################
#######    scenario : Add a monogram to a suitable (formal or evening) shirt displayed on the product page
###########################################################################################################
When /^I make a selection for "(.*?)", "(.*?)" and "(.*?)" and enter text into "(.*?)"$/ do |font, colour, position, initials|
  ############################################################
  # set the font, colour, position and initials to the value specified in the scenario data
  ############################################################
  fail "\nERROR: \'font\' specified in scenario data table is invalid." if !ALL_MG_FONTS.include? font.downcase
	@detailPage.mg_font = font.downcase

  fail "\nERROR: \'colour\' specified in scenario data table is invalid." if !ALL_MG_COLOURS.include? colour.downcase
	@detailPage.mg_colour = colour.downcase

	fail "\nERROR: \'position\' specified in scenario data table is invalid. It must be one of \'chest (left)\', \'cuff centre\', \'cuff above watch\' or \'cuff below link\'" if !ALL_MG_POSITIONS.include? position.downcase
	@detailPage.mg_position = position.downcase

  @detailPage.mg_initials = initials
  sleep 3
end

And /^I click on the Add Monogram button$/ do
  @detailPage.confirm_add_monogram
end

Then /^the Add Monogram lightbox closes$/ do
  expect(@detailPage.monogram_lightbox_displayed?).to be(FALSE)
end

And /^the product item detail page is still displayed$/ do
# CHECK PAGE ELEMENTS PRESENT
end

And /^the Add Monogram checkbox is checked$/ do
  expect(@detailPage.add_monogram_checked?).to be(TRUE)
end

And /^the monogram summary details for "(.*?)", "(.*?)", "(.*?)" and "(.*?)" are displayed next to the Add Monogram checkbox on the product item detail page$/ do |font, colour, position, initials|
  expect(@detailPage.monogram_description_displayed?).to be(TRUE)
  expect(@detailPage.monogram_description.empty?).to be(FALSE)
  log("MONOGRAM DESCRIPTION = '#{@detailPage.monogram_description}'") if ENABLED_LOGGING

  # The monogram text description eg. "You selected: brush script,black,\"AQA\",chest"
  # is delimited by commas so we SPLIT it into 4 parts, and then compensate for the \"<initials>\" component
  monogram_desc = @detailPage.monogram_description.sub(/You selected:\s*/,'').split ','
  font_displayed = monogram_desc[0]
  colour_displayed = monogram_desc[1]
  initials_displayed = monogram_desc[2].gsub("\\",'')
  position_displayed = monogram_desc[3]

  # wrap " " around initials to match the monogram text description displayed on the web page
  #initials_str = '"' + initials + '"'

  # now compare the monogram text description with the values from the scenario data table
  expect(font.downcase).to eq(font_displayed.downcase)
  expect(colour.downcase).to eq(colour_displayed.downcase)
  expect(initials.downcase).to eq(%Q("#{initials_displayed}").downcase)
  expect(position.downcase).to eq(position_displayed.downcase)
end
