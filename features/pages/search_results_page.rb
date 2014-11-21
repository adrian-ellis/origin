class SearchResultsPage
  # include common methods for page object classes (located in common_modules.rb)
  include CommonProductPageMethods
  include CommonPageMethods
  include Waiting
  include TeliumTags

  #######################################################################
  # define page object methods on the search results page
  #######################################################################
  def initialize(browser,country)
    @browser = browser
    @country = country
  end

  # the clothing items displayed within the product listing section
  def clothing_item_result_links
    if @country != DE
      @browser.div(:id => "ctl00_contentBody_productListingSection").links(:class => "img")
    else
      @browser.div(:id => "ctl00_contentBody_productListingSection").links(:class => "img")
    end
  end

  # Get the item codes (SKU's) for the top row of product items
  def get_top_row_result_items
    top_row_items = []
    clothing_item_result_links.each do |link|
      item_codes_from_url = link.href.split "|"
      item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]
      top_row_items.push(item_product_code)
      break if top_row_items.length == NUMBER_OF_FIRST_ROW_ITEMS
    end
    return top_row_items
  end
end
