class SearchNoResultsPage
  # include common methods for page object classes (located in common_modules.rb)
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
      @browser.div(:id => "ctl00_contentBody_productListingSection").exists?
  end

  # Confirm there no item codes (SKU's) for product items on this page
  def found_result_items
    return clothing_item_result_links
  end
end