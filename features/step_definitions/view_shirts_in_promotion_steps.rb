Given /^there are "(.*)" eligible shirts in my basket$/ do |current_basket_total|

  # need to find the item detail page for any shirt product that triggers the offer (ie. 4 for £100 shirts)
  product_item_code = "FP002WHT"

  # add quantity 'current_basket_total' of any suitable shirt to the basket
  quantity_of_items = Integer(current_basket_total)
  quantity_of_items.times do
    # Load the formal shirt product page for the shirt specified in the current row of the scenario data table
    #COLLAR_SIZE = "14.5"
    @slv_table_values = {}
    @frmlProdPage = FormalShirtsPage.new(@browser,GB)
    @page = @frmlProdPage.load_formal_shirt_detail_page(product_item_code)
    @page.wait_until_element_present(@page.sleeve_length_select_box)
    @page.open_sleeve_length_select_box
    @page.set_sleeve_length_by_index(3)
    @page.add_to_basket
  end
end

When /^I select View Shirts for "(.*?)" in the lightbox popup$/ do |amount|
  @time_secs = 0
  until @page.fries_popup.exists? == TRUE
    @time_secs+=1
    break if @time_secs > 20
    sleep 1
  end

  puts "\nERROR: Fries popup didn\'t open even after a 20 second wait" if @time_secs > 20
  @page.fries_popup.exists?.should == TRUE
  @page.fries_offer_link.click
end

Then /^the shirt product page containing the shirts available to buy in the offer is displayed$/ do
  @time_secs = 0
  until @page.url.include? ("shirts-multi-buy-offer")
    @time_secs+=1
    break if @time_secs > 20
    sleep 1
  end

  puts "\nERROR: Page showing shirts in promotion didn\'t load even after a 20 second wait" if @time_secs > 20
  @page.url.should include ("shirts-multi-buy-offer")
end
