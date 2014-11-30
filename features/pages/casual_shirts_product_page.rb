class CasualShirtsPage
  # include common methods for page object classes (located in common_modules.rb)
  include Capybara::DSL
  include CapybaraCustomSelectors
  include WaitForAjax
  include CommonProductPageMethods
  include TopMenuNavigationMethods
  include LeftNavigationMethods
  include Waiting
  include Lightboxes
  include TeliumTags

  #######################################################################
  # define page objects on the casual shirts product page
  #######################################################################
  def initialize(page,country)
    @page = page
    @country = country

    # Load the Casual Shirts Product page for the given country when a new instance of this 'page object' is created (if it's not already loaded).
    # We do this here because, it's possible to load the Casual Shirts Product from the top level menus on most other ctshirts website pages.
    casual_shirt_url_str = {'GB' => CASUAL_SHIRT_IDENTIFIER_GB, 'US' => CASUAL_SHIRT_IDENTIFIER_US, 'AU' => CASUAL_SHIRT_IDENTIFIER_AU, 'DE' => CASUAL_SHIRT_IDENTIFIER_DE}
    goto_casual_shirts_product_page(country) if !Capybara.current_session.current_url.include? casual_shirt_url_str[country]
  end
  
  ###########################################################################################################################################
  # find a product item's category codes and verify they are correct (for the filter(s) currently selected on the casual shirts product page)
  # the comparison is done with the data in the hashes (eg. FIT_LIST, COLOUR_LIST) defined in common_modules.rb
  ###########################################################################################################################################
  def find_items_category_codes(category_codes, code_type)
    code_found = FALSE
	  case
      when code_type == 'size'
        list = SIZE_LIST
	    when code_type == "fit"
        list = FIT_LIST
	    when code_type == "colour"
        list = COLOUR_LIST
	    when code_type == "range"
        list = RANGE_LIST
	    else
	      return code_found
	  end
	
    category_codes.each do |code|
      list.select { |key,val| code_found = TRUE if (list[key] == code) }
	  end
    return code_found
  end

end