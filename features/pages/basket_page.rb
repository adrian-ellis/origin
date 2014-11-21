FIELDSET_PRODUCT_ITEM_SUFFIX = '_it'
INDEX_FOR_STOCK_CODE = 2

class BasketPage
  # include common methods for page object classes (located in common_modules.rb)
  include CapybaraCustomSelectors
  include CommonPageMethods
  include Waiting
  include Lightboxes
  include TeliumTags

  #######################################################################
  # Define "Basket" page objects and methods that call them
  #######################################################################
  def initialize(page, country)
    @page = page
    @country = country
  end

  ####################################################################################################################################
  # "Basket" page objects (elements or groups of elements)
  ####################################################################################################################################
  def secure_checkout_button
    @page.button('ctl00_contentBody_submit')
  end

  def product_item_fieldsets
    #@browser.fieldsets(:id => /\d+(_it)/, :class => "product item")
    @page.all(:css, %q(fieldset[id*="_it"][class="product item"]))
  end

  def first_product_item_fieldset
    #@browser.fieldset(:id => /\d+(_it)/, :class => "product item")
    @page.first(:css, %q(fieldset[id*="_it"][class="product item"]))
  end

  # Set of links for updating items from the basket
  def all_item_update_qty_links
    @page.find(:div_id, "basketItem").all(:link_has_href, 'update-item')
  end

  # Set of links for removing items from the basket
  def all_item_removal_links
    @page.find(:div_id, "basketItem").all(:link_has_href, 'remove-item')
  end

  ####################################################################################################################################
  # Basket Subtotal, Delivery and Total Prices
  ####################################################################################################################################
  def basket_subtotal_dd_element
    #@page.fieldset(:class => "footer").div(:id => "summary", :class => "costs").dl(:class => "subtotal").dd(:class => "price")
    @page.find(:css, 'fieldset.footer div#summary.costs dl.subtotal dd.price')
  end

  def basket_subtotal_amount
    basket_subtotal_dd_element.text
  end

  def delivery_amount
    #@page.fieldset(:class => "footer").div(:id => "summary", :class => "costs").div(:class => "summary-footer").dl(:class => "offer_costs delivery").dd(:class => "price").text
    @page.find(:css, 'fieldset.footer div#summary.costs div.summary-footer dl.offer_costs delivery dd.price').text
  end

  def basket_total_amount
    #@page.fieldset(:class => "footer").div(:id => "summary", :class => "costs").div(:class => "summary-footer").dl(:class => "total").dd(:class => "price").text
    @page.find(:css, 'fieldset.footer div#summary.costs div.summary-footer dl.total dd.price').text
  end

  ####################################################################################################################################
  # Methods calling "Basket" page objects
  ####################################################################################################################################

  def proceed_to_secure_checkout
    wait_until_element_present { @page.button('ctl00_contentBody_submit') }
    @page.click_button('ctl00_contentBody_submit')
    return DeliveryPage.new(@page, @country)
  end

  # item quantity update link (use to change the quantity no. of a specific item with a given 'item id')
  def item_update_qty_link(data_item_id)
    product_item_fieldset(data_item_id).find('a.update[href*="update-item"]')
  end

   # item removal link for an item with a given 'item id'
  def item_removal_link(data_item_id)
    product_item_fieldset(data_item_id).find('a.remove[href*="remove-item"]')
  end

  # This is the root element for a given item with 'item id' (anything relating to the item is found under this element)
  def product_item_fieldset(data_item_id)
    id = data_item_id + '_it'
    #@page.fieldset(:id => "#{id}", :class => "product item")
    @page.find(:css, "fieldset[id='#{id}']")
  end

  # the image link whose URL holds the product item code
  def item_image_link(data_item_id)
	  product_item_fieldset(data_item_id).find(:link_class, 'img')
  end

  # description of item (ie. 'Size' of shirt)
  def product_item_description(data_item_id)
    product_item_fieldset(data_item_id).find('div.item_desc p[class="meta desc"]')
  end

  # the price of the item
  def item_price_amount(data_item_id)
    id = data_item_id + '_pr'
	  #product_item_fieldset(data_item_id).div(:class => "price", :id => "#{id}").ins(:class => /.*/).text
	  a = product_item_fieldset(data_item_id).find("div.price[id='#{id}'] ins[data-total]").text
    product_item_fieldset(data_item_id).find("div.price[id='#{id}'] ins[data-total]").text
  end

  # the types of the customisation for the given item (eg. added pocket)
  def item_customisation_types(data_item_id)
    all_types_array = []
    id = data_item_id + '_spp'

    return [] if product_item_fieldset(data_item_id).has_no_selector?(:css, "div.sppt_info[id='#{id}']")
    all_types = product_item_fieldset(data_item_id).all(:css, "div.sppt_info[id='#{id}'] div.customisations dt")

    if all_types.count == 1
      all_types_array << all_types.first.text
    else
      all_types.each { |amount| all_types_array << amount.text }
    end
    return all_types_array
  end

  # the price of the customisation to the item
  def item_customisation_amount(data_item_id)
    id = data_item_id + '_spp'
    #return "0" if !product_item_fieldset(data_item_id).div(:class => "sppt_info", :id => "#{id}").exists?
    return "0" if product_item_fieldset(data_item_id).has_no_selector?(:css, "div.sppt_info[id='#{id}']")
    #product_item_fieldset(data_item_id).div(:class => "sppt_info", :id => "#{id}").div(:class => "customisations").dd(:class => "price").text
    product_item_fieldset(data_item_id).find(:css, "div.sppt_info[id='#{id}'] div.customisations dd.price").text
  end

  # the price of EACH of the customisations to the item
  def item_customisation_amounts(data_item_id)
    all_amounts_array = []
    id = data_item_id + '_spp'

    return [] if product_item_fieldset(data_item_id).has_no_selector?(:css, "div.sppt_info[id='#{id}']")
    all_amounts = product_item_fieldset(data_item_id).all(:css, "div.sppt_info[id='#{id}'] div.customisations dd.price")

    if all_amounts.count == 1
      all_amounts_array << all_amounts.first.text
    else
      all_amounts.each { |amount| all_amounts_array << amount.text }
    end
    return all_amounts_array
  end

  # the item quantity in the basket
  def basket_item_quantity(data_item_id)
    id = data_item_id + '_qty'
    product_item_fieldset(data_item_id).find("fieldset.quantity span.inpt input[id*='#{id}']").value
    #product_item_fieldset(data_item_id).fieldset(:class => "quantity").span(:class => "inpt").text_field(:id => "#{id}").value
  end

  # item quantity text box (stores the quantity no. of a specific product item)
  def item_quantity_text_box(data_item_id)
    id = data_item_id + '_qty'
    @qty_text_box = product_item_fieldset(data_item_id).find("fieldset.quantity span.inpt input[id*='#{id}']")
  end

  def set_item_quantity(data_item_id, updated_quantity)
    fail "ERROR: Cannot find Item Quantity text box for item #{data_item_id}" if @page.has_no_selector?("fieldset.quantity span.inpt input[id*='#{id}']")
    #@qty_text_box_returned.when_present.set "#{updated_quantity}"
    product_item_fieldset(data_item_id).fill_in("fieldset.quantity span.inpt input[id*='#{id}']", :with => updated_quantity)
  end

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------
#########################################################################################################################################################
# Utility methods for basket page
#########################################################################################################################################################
#--------------------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------
  # Wait (up to 15 secs) for the basket page to refresh. Compare the current basket subtotal to the value before the update (on the target item quantity).
  # In most scenarios the basket subtotal should change, so this is a good indicator as to when the page is refreshed. If not, a 15secs wait is OK.
  def wait_until_basket_refreshes(orig_subtotal)
    time_secs = 0
    until time_secs == 15
      wait_until_element_present { @page.find(:css, 'fieldset.footer div#summary.costs dl.subtotal dd.price') }  # wait until the basket subtotal 'dd' element is loaded
      subtotal = basket_subtotal_amount
      break if subtotal != orig_subtotal
      sleep 1
      time_secs+=1
      puts "\nWaited #{time_secs} secs for basket refresh." if ENABLED_LOGGING
    end
  end

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ######################################################################################################################
  # Get the item id, item code, name, description, quantity, price and customisation prices for each item in the basket.
  # Create an array of hashes that contains all this data.
  ######################################################################################################################
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  def get_all_basket_items
    Decimal dcml_basket_subtotal_amount = 0
    Decimal dcml_item_price             = 0
    Decimal dcml_custom_amount          = 0
    Decimal dcml_total_custom_amount    = 0
    Decimal dcml_total_of_item_prices   = 0
    basket_item_hash                    = {}
    all_basket_items_hashes             = []

    ##################################################################################################################################################################
    # For each item find its item id, item code, name, description, quantity, price and customisation prices (ie. monogram, pocket, sleeve option for formal shirts)
    ##################################################################################################################################################################
    wait_until_element_present(first_product_item_fieldset)
    product_item_fieldsets.each do |item|
      # get item code from image link
      item_codes_from_url = item.find(:link_class, "img")['href'].split "|"
      item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

      # get data-item-id (that is used as a key to locate each item in the basket)
      id_attribute = item['id']
      item_id = id_attribute.sub(FIELDSET_PRODUCT_ITEM_SUFFIX,'')

      ################################################################################################
      # get item quantity, price and name (eg. red check long sleeve slim fit shirt) and description
      ################################################################################################
      item_quantity = basket_item_quantity(item_id)
      item_price_text = item_price_amount(item_id).sub(/[^\d]/,'')
      dcml_item_price = Decimal(item_price_text)
      #item_name = item.div(:class => "item_desc").h2(:class => "prod_name").link(:href => /#{item_product_code}/).text
      item_name = item.find("div.item_desc h2.prod_name a[href*='#{item_product_code}']").text
      item_description = product_item_description(item_id).text

      #########################################################################################################################################################################################
      # Find the item's customisation costs, and add them together. There can 3 of these costs for formal shirts (Note: Must remove '£' sign from the text string, which is the 1st character).
      #########################################################################################################################################################################################
      item_customisation_amounts(item_id).each do |amount|
        custom_amount_text = amount.sub(/[^\d]/,"").strip
        dcml_custom_amount = Decimal(custom_amount_text)
        dcml_total_custom_amount = dcml_total_custom_amount + dcml_custom_amount
      end

      # add the current item's price to the total price
      dcml_total_of_item_prices = dcml_total_of_item_prices + dcml_item_price

      ################################################################################################
      # Add this item (with its details) to the item array of hashes 'all_basket_items_hashes'
      ################################################################################################
      basket_item_hash.merge!('item_id' => item_id, 'item_code' => item_product_code, 'name' => item_name, 'description' => item_description , 'qty' => item_quantity, 'price' => dcml_item_price.to_s, 'customisation_price' => dcml_total_custom_amount.to_s)
      all_basket_items_hashes.push(basket_item_hash)
      basket_item_hash = {}  # clear the hash for the next item
      dcml_total_custom_amount = 0 # clear customisation amount too
    end

    # verify that the total we calculated by adding all the item's prices together (ie. the accumulated total amount) is equal to the subtotal displayed on the basket page
    dcml_basket_subtotal_amount = Decimal(basket_subtotal_amount.sub(/[^\d]/,''))
    if dcml_total_of_item_prices != dcml_basket_subtotal_amount
      fail "ERROR: The accumulated total amount in the Basket #{dcml_total_of_item_prices} does not equal the subtotal #{dcml_basket_subtotal_amount}"
    end

    return all_basket_items_hashes
  end

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ######################################################################################################################
  # Get the subtotal, total and delivery prices for the contents of basket.
  # Create a hash that contains this data.
  ######################################################################################################################
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  def get_basket_totals
    Decimal dcml_delivery_amount        = 0
    Decimal dcml_basket_subtotal_amount = 0
    Decimal dcml_basket_total_amount    = 0
    free_delivery                       = FALSE
    basket_totals_hash                  = {}

    # get the subtotal, delivery and total prices that are displayed on the basket page
    wait_until_element_present { @page.find(:css, 'fieldset.footer div#summary.costs dl.subtotal dd.price') }   # wait until the basket subtotal 'dd' element is loaded

    # In the case of free delivery, check if delivery amount contains the word 'free' or 'frei' (in German language)
    free_delivery = TRUE if (delivery_amount.downcase.include? 'free') || ((@country == DE) && (delivery_amount.downcase.include? 'frei'))

    if !free_delivery
      # Fail the test if the delivery amount (excluding the first character) contains any non-digit characters excluding those used in currencies (typically ',' or '.').
      # This is because the delivery is not free, and we cannot be sure what the non-digit characters actually mean!
      del_str = delivery_amount.sub(/./,'').sub(/,/,'').sub(/[^\d]/,'')
      fail "ERROR: Delivery amount #{delivery_amount} is not numeric so it cannot be added to the subtotal #{basket_subtotal_amount}" if del_str[/^[\d]+$/] == nil
    end
    dcml_delivery_amount = Decimal(delivery_amount.sub(/[^\d]/,'')) if !free_delivery
    dcml_basket_subtotal_amount = Decimal(basket_subtotal_amount.sub(/[^\d]/,''))
    dcml_basket_total_amount    = Decimal(basket_total_amount.sub(/[^\d]/,''))

    # add to the hash 'basket_totals_hash'
    basket_totals_hash.merge!('subtotal' => dcml_basket_subtotal_amount.to_s, 'delivery' => dcml_delivery_amount.to_s, 'total' => dcml_basket_total_amount.to_s)

    # verify that the subtotal, total and delivery figures displayed on the basket page are consistent with each other. The subtotal + delivery = total
    if dcml_basket_total_amount != dcml_basket_subtotal_amount + dcml_delivery_amount
      fail "ERROR: The total amount in the Basket \'#{dcml_basket_total_amount}\' does not equal the subtotal \'#{dcml_basket_subtotal_amount}\' plus delivery \'#{dcml_delivery_amount}\'"
    end

    return basket_totals_hash
  end

  ######################################################################################################################
  # remove item with a given data item id
  ######################################################################################################################
  def remove_item(target_item_id)
    # Find the 'removal' link for the item with 'data-item-id' matching the target item's ID. Then click this link.
    fail "ERROR: Cannot find 'Remove Item' link for Item with ID #{target_item_id}" if !item_removal_link(target_item_id).exists?
    item_removal_link(target_item_id).click
  end

  ######################################################################################################################
  # remove all items currently in the basket
  ######################################################################################################################
  def remove_all_items
    all_data_item_ids = []
    all_data_item_codes = []

    wait_until_element_present(main_page_section)   ##   @browser.div(:id => "content", :class => "section")
    return if !first_product_item_fieldset.exists?

    product_item_fieldsets.each do |item|
      # get item code from image link
      #item_codes_from_url = item.link(:class => "img", :href => /.*/).href.split "|"
      item_codes_from_url = item.find(:link_class, "img")['href'].split "|"
      item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

      # get data-item-id (that is used as a key to locate each item in the basket)
      id_attribute = item['id']
      data_item_id = id_attribute.sub(FIELDSET_PRODUCT_ITEM_SUFFIX,'')

      # store data-item-id in an array (that we can use later to retrieve all information relating to each item)
      all_data_item_ids.push(data_item_id)
      all_data_item_codes.push(item_product_code)
    end

    # Remove each item from the basket by clicking on each item's 'removal' link.
    # Note we must wait for the subtotal (found by method 'basket_subtotal_amount') to refresh between removals.
    all_data_item_ids.each do |item_id|
      wait_until_element_present { @page.find(:css, 'fieldset.footer div#summary.costs dl.subtotal dd.price') }  # wait until the basket subtotal 'dd' element is loaded
      subtot = basket_subtotal_amount
      item_removal_link(item_id).click
      wait_until_basket_refreshes(subtot)
    end

    puts "\nINFO: Removed ALL items from basket. Items removed had item codes #{all_data_item_codes}" if ENABLED_LOGGING
  end

  ######################################################################################################################
  # update the quantity for a given data item id
  ######################################################################################################################
  def item_update_quantity(target_item_id)
    item_update_qty_link(target_item_id).click
  end

end