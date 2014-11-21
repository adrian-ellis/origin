class OrderConfirmationPage
  # include common methods for page object classes (located in common_modules.rb)
  include CommonPageMethods
  include Waiting
  include TeliumTags

  #######################################################################
  # define page object elements on the "basket" page
  #######################################################################
  def initialize(browser,country)
    @browser = browser
    @country = country
  end

  # The header element for the order confirmation message
  def confirmation_message_header
    @browser.div(:id => "content").div(:class => "header").h1(:class => /confirm-order/)
  end

  def confirmation_message_header_is_present
    @browser.div(:id => "content").div(:class => "header").h1(:class => /confirm-order/).when_present.exists?
  end

  # A set of 'divs', where each 'div' represents the root element for each item in the completed order
  def product_items
    @browser.div(:class => "order_details section").divs(:class => "product item")
  end

  ######################################################################################################################
  # Find the order reference number (remove the leading 'w' if it exists. 'w' identifies a Web order)
  ######################################################################################################################
  def order_reference_number
    @browser.div(:class => "order_summary section").elements(:class => /.*/).each do |element|
      return element.text[/[^w].*/] if element.tag_name == "strong"
    end

    # Fail the test if we cannot find the order reference number
    fail "ERROR: Cannot find the order reference number on the 'Order Confirmation' page"
  end

  ######################################################################################################################
  # Returns a hash containing the item codes (SKU's), names, quantities and prices of all the items in the order
  ######################################################################################################################
  def get_order_product_details(format_for_telium_tests)
    telium_item_codes      = []
    telium_product_names   = []
    telium_product_qtys    = []
    telium_product_prices  = []
    order_item_hash        = {}
    all_order_items_hashes = []

    # Perform this loop for each product item found on the order confirmation page
    product_items.each do |item|
      # the element containing the product name
      product_name = item.h3(:class => "prod_name").text

      # the element containing the item code (SKU) for this product
      item_code = item.span(:class => "meta sku").element(:tag_name => "cufon").attribute_value("alt")

      # the element containing the quantity of this product
      product_qty = item.div(:class => "item_details").div(:class => "quantity").html[/\d+/]

      # the element containing the product price
      product_price = item.div(:class => "item_details").div(:class => "price").ins(:class => '').text.sub(/[^\d]/,'')

      ######################################################################################################################
      # The Telium tag tests require the above data in a different format to any other tests because of the way the Telium tag data
      # is stored on the webpages (ie. it's clumped together in different arrays for item codes, product names, qtys and prices).
      # This is the reason why this method 'get_order_product_details' returns the data differently for the Telium tests.
      ######################################################################################################################
      if format_for_telium_tests
        # For Telium tests, add the above values to the arrays that contain all the item details for the order
        telium_item_codes.push(item_code)
        telium_product_names.push(product_name)
        telium_product_qtys.push(product_qty)
        telium_product_prices.push(product_price)
      else
        # For any other tests, add the details for the current item to an array of hashes named 'all_order_items_hashes'
        order_item_hash.merge!('item_code' => item_code, 'name' => product_name, 'qty' => product_qty, 'price' => product_price)
        all_order_items_hashes.push(order_item_hash)

        # clear the item detail hash, ready for the next item in the order
        order_item_hash = {}
      end
    end

    if format_for_telium_tests
      return { 'item_codes' => telium_item_codes, 'product_names' => telium_product_names, 'product_qtys' => telium_product_qtys, 'product_prices' => telium_product_prices }
    else
      return all_order_items_hashes
    end
  end

  ######################################################################################################################
  # Returns a hash containing the subtotal, delivery and for total the order
  ######################################################################################################################
  def get_order_totals
    free_delivery = FALSE

    # the element containing the order subtotal
    subtotal = @browser.div(:class => "footer").dl(:class => "subtotal").dd(:class => "price").text.sub(/[^\d]/,'')

    # the element containing the delivery charge
    delivery = @browser.div(:class => "footer").div(:class => "last double mod").dd(:class => "price").text

    # In the case of free delivery, check if delivery amount contains the word 'free' or 'frei' (in German language). If it doesn't then remove the '£' sign (or equivalent).
    free_delivery = TRUE if (delivery.downcase.include? 'free') || ((@country == DE) && (delivery.downcase.include? 'frei'))
    delivery.sub!(/[^\d]/,'') if !free_delivery

    # the element containing the order total
    total = @browser.div(:class => "footer").dl(:class => "total").dd(:class => "price").text.sub(/[^\d]/,'')
    return { 'subtotal' => subtotal, 'delivery' => delivery, 'total' => total }
  end

end