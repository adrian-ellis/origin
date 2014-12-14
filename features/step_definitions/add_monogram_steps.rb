Given /^I add a monogram to product "([^\"]*)" in country "([^\"]*)"$/ do |product_item_code, country|
  add_monogram(product_item_code, country)
  puts "\n\nINFO: Finished adding monogram #{product_item_code} for #{country}\n"
end

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
#  wait_until_has_selector('fieldset#monogram')
  #wait_until_has_hash_selector(@detailPage.selector[:mg_lightbox])
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
end

And /^I click on the Add Monogram button$/ do
  # problem with focus within browser page before we click on the add monogram button, so use some jquery to focus on the button
  evaluate_script("$('fieldset#monogram img#ctl00_contentBody_ctl02_ctl00_addMono').trigger('focus')")
  @detailPage.confirm_add_monogram
end

Then /^the Add Monogram lightbox closes$/ do
#  wait_until_selector_not_visible('fieldset#monogram')
#  wait_until_has_no_selector('fieldset#monogram')
#  wait_until_hash_selector_not_visible(@detailPage.selector[:mg_lightbox])
  expect(@detailPage.monogram_lightbox_not_displayed?).to be(TRUE)
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

  mg_selection = @detailPage.get_monogram_selections(@detailPage.monogram_description)

  # now compare the monogram text description with the values from the scenario data table
  expect(font.downcase).to eq(mg_selection[:font].downcase)
  expect(colour.downcase).to eq(mg_selection[:color].downcase)
  expect(initials.downcase).to eq(mg_selection[:initials].downcase)
  if (@country != 'DE')
    expect(position.downcase).to eq(mg_selection[:position].downcase)
  else
    expect(ALL_MG_POSITIONS_DE[position].downcase).to eq(mg_selection[:position].sub(/.ber/,'uber').downcase)
  end
end