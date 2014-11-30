class AllShirtsPage

  # include common methods for page object classes (located in common_modules.rb)
  include Capybara::DSL
  include CapybaraCustomSelectors
  include WaitForAjax
  include CommonProductPageMethods
  include CommonPageMethods
  include TopMenuNavigationMethods
  include LeftNavigationMethods
  include Waiting
  include Lightboxes
  include TeliumTags

  #######################################################################
  # define page objects on the (all) shirts product page
  #######################################################################
  def initialize(page, country)
    @page = page
    @country = country

    # Load the Shirts Product page for the given country when a new instance of this 'page object' is created (if it's not already loaded).
    # We do this here because, it's possible to load the Shirts Product from the top level menus on most other ctshirts website pages.
    shirt_url_str = {'GB' => ALL_SHIRTS_IDENTIFIER_LANG_EN, 'US' => ALL_SHIRTS_IDENTIFIER_LANG_EN, 'AU' => ALL_SHIRTS_IDENTIFIER_LANG_EN, 'DE' => ALL_SHIRTS_IDENTIFIER_LANG_DE}
    goto_all_shirts_product_page(country) if !Capybara.current_session.current_url.include? shirt_url_str[country]
  end

  # Select 'size' within the left hand navigation controls
  def select_size(size)
    if @country != DE
      @browser.div(:id => "Size").ul(:class => "navList").link(:href => ALL_SHIRTS_IDENTIFIER_LANG_EN, :title => size).when_present.click
    else
      @browser.div(:id => "Size").ul(:class => "navList").link(:href => ALL_SHIRTS_IDENTIFIER_LANG_DE, :title => size).when_present.click
    end
  end

  # find the 'Collar ize' links within the left hand navigation controls on the formal shirts product page
  def collar_size_links
    if @country != DE
      @browser.div(:id => "collar").ul(:class => "navList").links(:href => ALL_SHIRTS_IDENTIFIER_LANG_EN)
    else
      @browser.div(:id => "collar").ul(:class => "navList").links(:href => ALL_SHIRTS_IDENTIFIER_LANG_DE)
    end
  end

  # Select 'collar size' within the left hand navigation controls
  def select_collar_size(collar_size)
    if @country != DE
      @browser.div(:id => "collar").ul(:class => "navList").link(:href => ALL_SHIRTS_IDENTIFIER_LANG_EN, :title => collar_size).when_present.click
    else
      @browser.div(:id => "collar").ul(:class => "navList").link(:href => ALL_SHIRTS_IDENTIFIER_LANG_DE, :title => collar_size).when_present.click
    end
  end

  # find the 'Sleeve length' links within the left hand navigation controls on the formal shirts product page
  def sleeve_length_links
    if @country != DE
      @browser.div(:id => "slvLnth").ul(:class => "navList").links(:href => ALL_SHIRTS_IDENTIFIER_LANG_EN)
    else
      @browser.div(:id => "slvLnth").ul(:class => "navList").links(:href => ALL_SHIRTS_IDENTIFIER_LANG_DE)
    end
  end

  # Select 'sleeve length' within the left hand navigation controls
  def select_sleeve_length(sleeve_length)
    if @country != DE
      @browser.div(:id => "slvLnth").ul(:class => "navList").link(:href => ALL_SHIRTS_IDENTIFIER_LANG_EN, :title => sleeve_length).when_present.click
    else
      @browser.div(:id => "slvLnth").ul(:class => "navList").link(:href => ALL_SHIRTS_IDENTIFIER_LANG_DE, :title => sleeve_length).when_present.click
    end
  end


  ###########################################################################################################################################
  # find a product item's category codes and verify they are correct (for the filter(s) currently selected on the all shirts product page)
  # the comparison is done with the data in the hashes (eg. FIT_LIST, COLLAR_SIZE_LIST) defined in common_modules.rb
  ###########################################################################################################################################
  def find_items_category_codes(category_codes, code_type)
    code_found = FALSE
    single_category_code = FALSE

    case
      when code_type == 'size'
        list = SIZE_LIST
      when code_type == 'collar_size'
        list = COLLAR_SIZE_LIST
        single_category_code = TRUE
      when code_type == "fit"
        list = FIT_LIST
      when code_type == "colour"
        list = COLOUR_LIST
      when code_type == "range"
        list = RANGE_LIST
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