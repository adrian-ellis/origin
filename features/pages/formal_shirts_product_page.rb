class FormalShirtsPage
  # include common methods for page object classes (located in common_modules.rb)
  include Capybara::DSL
  include CapybaraCustomSelectors
  include CommonProductPageMethods
  include CommonPageMethods
  include TopMenuNavigationMethods
  include LeftNavigationMethods
  include Waiting
  include Lightboxes
  include TeliumTags

  #######################################################################
  # define page elements/methods on the formal shirts product page
  #######################################################################
  def initialize(page, country)
    @page = page
    @country = country

    # Load the Formal Shirts Product page for the given country when a new instance of this 'page object' is created (if the page is not already loaded).
    # We do this here because, it's possible to load the Formal Shirts Product from the top level menus on most other ctshirts website pages.
    formal_shirt_url_str = {'GB' => FORMAL_SHIRT_IDENTIFIER_GB, 'US' => FORMAL_SHIRT_IDENTIFIER_US, 'AU' => FORMAL_SHIRT_IDENTIFIER_AU, 'DE' => FORMAL_SHIRT_IDENTIFIER_DE}
    goto_casual_shirts_product_page(country) if !Capybara.current_session.current_url.include? formal_shirt_url_str[country]
  end

  # find the 'Collar ize' links within the left hand navigation controls on the formal shirts product page
  def collar_size_links
    if @country != DE
      @page.find(:div_id, "formal-shirt-collar-size").all(:link_href_has, FORMAL_SHIRT_IDENTIFIER_GB)
    else
      @page.find(:div_id, "formal-shirt-collar-size").all(:link_href_has, FORMAL_SHIRT_IDENTIFIER_DE)
    end
  end

  # Select 'collar size' within the left hand navigation controls
  def select_collar_size(collar_size)
    @page.find(:div_id, "formal-shirt-collar-size").click_link(collar_size)
  end

  # find the 'Sleeve length' links within the left hand navigation controls on the formal shirts product page
  def sleeve_length_links
    if @country != DE
      @page.find(:div_id, "formal-shirt-sleeve-length").all(:link_href_has, FORMAL_SHIRT_IDENTIFIER_GB)
    else
      @page.find(:div_id, "formal-shirt-sleeve-length").all(:link_href_has, FORMAL_SHIRT_IDENTIFIER_DE)
    end
  end

  # Select 'sleeve length' within the left hand navigation controls
  def select_sleeve_length(sleeve_length)
    @page.find(:div_id, "formal-shirt-sleeve-length").click_link(sleeve_length)
  end

  ###########################################################################################################################################
  # find a product item's category codes and verify they are correct (for the filter(s) currently selected on the formal shirts product page)
  # the comparison is done with the data in the hashes (eg. FIT_LIST, COLLAR_SIZE) defined in common_modules.rb
  ###########################################################################################################################################
  def find_items_category_codes(category_codes, code_type)
    code_found = FALSE
    single_category_code = FALSE
    case
	    when code_type == "FIT"
        list = FIT_LIST
	    when code_type == "COLOUR"
        list = COLOUR_LIST
	    when code_type == "COLLAR_SIZE"
        list = COLLAR_SIZE_LIST
        single_category_code = TRUE
	    else
	      return code_found
    end

    # Note: if category code is a single element array we CANNOT use the "each" method
    if single_category_code != TRUE
      category_codes.each do |code|
        list.select { |key,val| code_found = TRUE if (list[key] == code) }
      end
    else
      list.select { |key,val| code_found = TRUE if (list[key] == category_codes) }
    end

    return code_found
  end
end