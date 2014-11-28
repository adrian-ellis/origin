module LogToFile
	def log(text)
		begin
			file = File.open(ENV['LOGFILE'], "a")
			file.write(text)
		rescue IOError => e
			#some error occur, dir not writable etc.
			puts "\nError '#{e}' writing to log file"
		ensure
			file.close unless file == nil
		end
	end
end

#-----------------------------------------------------------------------------------------------------------------------------------------------------
######################################################################################################################################################
# MODULE CONTAINING Methods to used by stepdefs to find JSON elements(objects) within a JSON file or string.
# NOTE: It needs the JsonPath gem to be installed first.
######################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------
module JsonDataQuerying
  def find_json_obj(data,arg)
    JsonPath.on(data,%Q($..#{arg}))
  end

  def find_json_objs(data,args)
    hash = {}
    return nil if !args.is_a? Array

    # Create a hash containing the results of the JsonPath query. The name of the JSON object we're searching for is 'arg' (the Key), and the JSON object
    # found is 'result' (the Value)
    args.each { |arg| result = JsonPath.on(data,%Q($..#{arg})); hash.merge!(arg => result) }
    return hash
  end
end

#-----------------------------------------------------------------------------------------------------------------------------------------------------
######################################################################################################################################################
# MODULE CONTAINING Methods used by stepdefs to verify (arg == TRUE)
######################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------
module BooleanExpectations
  def Expect(arg)
    expect(arg).to be TRUE
  end

  def Not_Expect(arg)
    expect(arg).to be FALSE
  end
end
#-----------------------------------------------------------------------------------------------------------------------------------------------------
######################################################################################################################################################
# MODULE CONTAINING Methods used to add custom Capybara selectors. These can be used to locate elements without writing complex XPath or CSS expressions.
######################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------
module CapybaraCustomSelectors
  # Add a custom Capybara selector that can be used to find any 'link' element with an 'href' attribute CONTAINING the text 'link_href'
  Capybara.add_selector(:link_href_has) do
    xpath { |link_href| XPath.css("a[href*='#{link_href}']") }
  end

  # Add a custom Capybara selector that can be used to find any 'link' element with an 'href' attribute EQUAL TO the text 'link_href'
  Capybara.add_selector(:link_href) do
    xpath do |link_href| 
			XPath.css("a[href='#{link_href}']")
		end
  end

  Capybara.add_selector(:link_class) do
    xpath { |classy| XPath.css("a[class='#{classy}']") }
  end

  Capybara.add_selector(:div_id) do
    xpath { |id| XPath.css("div[id='#{id}']") }
  end

  Capybara.add_selector(:div_class) do
    xpath { |classy| XPath.css("div[class='#{classy}']") }
  end

  Capybara.add_selector(:li_class) do
    xpath { |classy| XPath.css("li[class='#{classy}']") }
  end

  Capybara.add_selector(:span_id) do
    xpath { |id| XPath.css("span[id='#{id}']") }
  end

  Capybara.add_selector(:span_class) do
    xpath { |classy| XPath.css("span[class='#{classy}']") }
  end

  Capybara.add_selector(:id) do
    xpath { |id| XPath.descendant[XPath.attr(:id) == id.to_s] }
  end

  Capybara.add_selector(:class) do
    xpath { |classy| XPath.descendant[XPath.attr(:class) == classy.to_s] }
  end

  Capybara.add_selector(:title) do
    xpath { |title| XPath.descendant[XPath.attr(:title) == title.to_s] }
  end

end
#-----------------------------------------------------------------------------------------------------------------------------------------------------
######################################################################################################################################################
# MODULE CONTAINING Methods used by env.rb
######################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------
module EnvMethods
  # Construct a filename (used for naming test results files) based on the Scenario name and timestamp
  def scenario_name(scenario)
    # If this is a scenario outline (with associated scenario data in table form), the scenario name is a combination of outline name and scenario data
    if scenario.instance_of?(Cucumber::Ast::OutlineTable::ExampleRow)
      scenario_name = scenario.scenario_outline.name.gsub(/[^\w\-]/, ' ')     # replace any non-word characters with spaces
      scenario_name += "-Example#{scenario.name.gsub(/\s*\|\s*/, '-')}".chop  # replace the ' | ' with '-' characters
    else
      scenario_name = scenario.name.gsub(/[^\w\-]/, ' ')
    end

    # Get current date and time
    time = Time.now.strftime("%Y-%m-%d-%H%M%S")

    # Return filename. Note that Windows has file name limits so limit the length of filename we return
    return "#{time}-#{scenario_name}".slice(0, 150).gsub(/[\,\/]/, '.')
  end
end

#-----------------------------------------------------------------------------------------------------------------------------------------------------
######################################################################################################################################################
# MODULE CONTAINING Methods to allow for waiting while AJAX requests complete
######################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------
# spec/support/wait_for_ajax.rb
module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    @page.evaluate_script('jQuery.active').zero?
  end
end

#-----------------------------------------------------------------------------------------------------------------------------------------------------
######################################################################################################################################################
# MODULE CONTAINING Methods to allow waiting for pages and page elements to load
######################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------
module Waiting
  # Verify that the specified element (called in the block, from 'yield') exists on the page (ie. within the DOM).
  # If the element can no longer be found within the because the DOM has changed (again), then catch the exception thrown,
  # and then try to locate it again (ie. with a new reference to the element). Fail if not found within time limit PAGE_ELEMENT_TIMEOUT_SECS.
  def wait_until_element_present
    element_present = FALSE
    time_secs = 0
    begin
      while !element_present
        fail "\nERROR: Element cannot be found even after #{PAGE_ELEMENT_TIMEOUT_SECS} secs\n" if time_secs > PAGE_ELEMENT_TIMEOUT_SECS
        element_present = yield
        break if element_present
        time_secs += time_secs + 0.5
      end
    rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
      puts "Trapped Exception: #{e} : Retrying"
      sleep 0.5
      time_secs += time_secs + 0.5
      retry
    rescue Selenium::WebDriver::Error::ObsoleteElementError => e
      puts "Trapped Exception: #{e} : Retrying"
      sleep 0.5
      time_secs += time_secs + 0.5
      retry
    end
  end

  # Verify that the specified element (called in the block, from 'yield') exists on the page (ie. within the DOM).
  # If the element can no longer be found within the because the DOM has changed (again), then catch the exception thrown,
  # and then try to locate it again (ie. with a new reference to the element). Reload the URL if not found within 'time_limit' secs.
  def reload_page_if_not_found(url, time_limit)
    element_present = FALSE
    time_secs = 0
    begin
      while !element_present
        break if time_secs > time_limit * 3
        @page.visit(url) if time_secs > time_limit
        element_present = yield
        time_secs += time_secs + 0.5
      end
    rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
      puts "Trapped Exception: #{e} : Retrying"
      sleep 0.5
      time_secs += time_secs + 0.5
      retry
    rescue Selenium::WebDriver::Error::ObsoleteElementError => e
      puts "Trapped Exception: #{e} : Retrying"
      sleep 0.5
      time_secs += time_secs + 0.5
      retry
    end
  end

  # Wait until the page url changes from its initial string value. This is useful when we have to wait
  # for the page to be reloaded before searching for specific elements on the page. Although WATIR should
  # wait for the page to load beforehand, it's an additional safety factor.
  def wait_until_page_loaded(page_name, prev_url)
    time_secs = 0
    while Capybara.current_session.current_url == prev_url
      break if time_secs > PAGE_TIMEOUT_SECS
      sleep 1
      time_secs+=1
    end
    fail "ERROR: Page #{page_name} failed to load after #{PAGE_TIMEOUT_SECS} secs" if Capybara.current_session.current_url == prev_url
  end

  #########################################################################################################
  # EXPERIMENTS WITH THESE METHODS THAT USE BLOCKS to retry locating a given element after a timeout occurs
  #########################################################################################################
  def retry_if_timed_out(waittime)
    begin
      Timeout::timeout(waittime)  do
        yield
      end
    rescue Timeout::Error => e
      puts "Page/Element load timed out: #{e} : retrying"
      retry
    end
  end

  # Wait up to 'time' in secs for that pesky element to appear
  def wait_until(time)
    time_secs = 0
    element_found = FALSE
    while !element_found
      break if time_secs > time
      element_found = yield
      sleep 0.5
      time_secs += 3.5 # use Time.now (secs) instead
    end
  end

  # USE THIS ONE !!!!!!!
  def trap_error
    time_secs = 0
    begin
      fail "\nERROR: #{e}\n" if time_secs > 5.0
      yield
    rescue Capybara::ElementNotFound => e
      fail "\nCapybara::ElementNotFound => #{e}\n"
    rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
      puts "\nError locating element: #{e} : retrying"
      sleep 0.5
      time_secs += 0.5
      retry
    rescue Selenium::WebDriver::Error::ObsoleteElementError => e
      puts "\nError locating element: #{e} : retrying"
      sleep 0.5
      time_secs += 0.5
      retry
    end
  end

  def trap_not_found
    time_secs = 0
    begin
      yield
    rescue Capybara::ElementNotFound => e
      puts "\nError locating element: #{e} : retrying"
      sleep 0.5
      time_secs += 0.5
      fail "\nCapybara::ElementNotFound => #{e}\n" if time_secs > 5.0
      retry
    end
  end


end


########################################################################################################################################################################
################################################ All Constants needed by MODULE CommonPageMethods ######################################################################
########################################################################################################################################################################
########################################################################################################################################################################
# Item identifiers for all men's shirts (ie. casual or formal) in both english and german languages. On both these shirts product pages these help to identify:-
#   1) the left navigation links
#   2) the shirt item thumbnail links
ALL_SHIRTS_IDENTIFIER_LANG_EN    = 'mens-shirts'
ALL_SHIRTS_IDENTIFIER_WQ_LANG_EN = "men's-shirts"
ALL_SHIRTS_IDENTIFIER_LANG_DE    = 'herren-hemden'

# Top (main menu) navigation control identifiers for casual and formal men's shirts for all countries
VIEW_ALL_SHIRTS_LANG_EN    = 'View all shirts'
VIEW_ALL_SHIRTS_LANG_DE    = 'Alle Hemden'

FORMAL_SHIRT_IDENTIFIER_GB = 'formal-shirts'
FORMAL_SHIRT_IDENTIFIER_US = 'dress-shirts'
FORMAL_SHIRT_IDENTIFIER_AU = 'business-shirts'
FORMAL_SHIRT_IDENTIFIER_DE = 'herren-businesshemden'

CASUAL_SHIRT_IDENTIFIER_GB = 'casual-shirts'
CASUAL_SHIRT_IDENTIFIER_US = 'sport-and-casual-shirts'
CASUAL_SHIRT_IDENTIFIER_AU = 'casual-shirts'
CASUAL_SHIRT_IDENTIFIER_DE  = 'herren-freizeithemden'

SEARCH_RESULTS_URL_IDENTIFIER    = "productlisting.aspx?q="
SEARCH_NO_RESULTS_URL_IDENTIFIER = "SearchNoResults.aspx?term="

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
########################################################################################################################################################################
# MODULE CONTAINING Methods which are common to all Pages
########################################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
module CommonPageMethods
  def url
    Capybara.current_session.current_url
  end

  ##########################################################################################
  # Get the number of items in the basket (returned as an integer)
  ##########################################################################################
  def get_number_of_items_in_basket
    while @page.find(:div_id,'basket_nav').has_selector?(:span_id,'miniBKQty', :minimum => 2) do
      sleep 0.5
    end

    result = @page.find(:div_id,'basket_nav').find(:span_id,'miniBKQty').text
    fail "\nERROR: Cannot find the number of items in the Basket" if (result.match /\D+/) || (result == nil)
    return result[/(\d+)/,1].to_i
  end

  ###########################################################################################################################################################
  # Loads the Basket page (Note: the country specified must be the same as the current ctshirts website country)
  ###########################################################################################################################################################
  def visit_checkout(country)
    while @page.find(:div_id,'basket_nav').has_selector?(:span_id,'miniBKQty', :minimum => 2) do
      sleep 0.5
    end

    @page.click_link('Shopping bag')
    return BasketPage.new(@page,country)
  end

  def checkout_link
    #@browser.link(:href => BASKET_LINK_URL)
    @page.link('Shopping bag')
  end

  ###########################################################################################################################################################
  # Opens the 'Country' lightbox, and loads the ctshirts home page for the specified country (eg. 'GE' for the German website)
  ###########################################################################################################################################################
  def change_country(country)
    all_countries = ['GB', 'US', 'AU', 'GE']
    fail "ERROR: Cannot navigate to website for country #{country}. Only 'GB', 'US', 'AU' and 'GE' are valid options. Please check this scenario's data table." if !all_countries.include? country

    # Opens the 'Country' lightbox
    @page.click_link('ctl00_contentFooter_ctlMegaFooter_ChangeCountry')

    # Find the link(s) for the country in the lightbox. Click on the first link (if links > 1). NOTE: The 'first' method also works if only 1 link is found.
    country_href_text = %Q(/Country/Change/#{country})
    country_links = @page.find(:div_id,'country-popup').all(:link_href_has,"#{country_href_text}")
    country_links.first.click
  end

  #---------------------------------------------------------------------------------------------------------------------
  ######################################################################################################################
  # Methods needed for the 'Search' (for products) facility available at the top of each page
  ######################################################################################################################
  #---------------------------------------------------------------------------------------------------------------------

  ##########################################################################################
  # Enter the specified text into the 'Search' text box at the top of the page
  ##########################################################################################
  def search_text_field
    @page.find('search_term')
  end

  def search_text=(text)
    @page.fill_in('search_term', :with => text)
  end

  ##########################################################################################
  # 'Search' button next to the 'Search' text box at the top of the page
  ##########################################################################################
  def submit_search
    @page.click_button('searchButton')
  end

  ##########################################################################################
  # Searches for the specified text which MUST NOT be a product item code (SKU)
  ##########################################################################################
  def search_for_text(text)
    fail "INTERNAL ERROR: In method call to 'search_for_text' no text was entered" if text == nil
    self.search_text = text
    submit_search
    if Capybara.current_session.current_url.include? SEARCH_RESULTS_URL_IDENTIFIER
      return SearchResultsPage.new(@page,@country)
    elsif Capybara.current_session.current_url.include? SEARCH_NO_RESULTS_URL_IDENTIFIER
      return SearchNoResultsPage.new(@page,@country)
    else
      fail "ERROR: Product Search for '#{text}' did not return the URL for either the 'SearchResults' or the 'SearchNoResults' page"
    end
  end

  ##########################################################################################
  # Searches for the specified text which MUST be a formal shirt item code (SKU)
  ##########################################################################################
  def search_for_formal_shirt(item_code)
    fail "INTERNAL ERROR: In method call to 'search_for_formal_shirt' no Item Code (SKU) was specified" if item_code == nil
    self.search_text = item_code
    submit_search
    fail "\nERROR: Check the 'scenario' data table for this 'feature'. The formal shirt item code is set to '#{item_code}' and cannot be found." if Capybara.current_session.current_url.include? SEARCH_NO_RESULTS_URL_IDENTIFIER
    return FormalShirtsItemDetailPage.new(@page,@country)
  end

  ##########################################################################################
  # searches for the specified text which MUST be a casual shirt item code (SKU)
  ##########################################################################################
  def search_for_casual_shirt(item_code)
    fail "INTERNAL ERROR: In method call to 'search_for_casual_shirt' no Item Code (SKU) was specified" if item_code == nil
    self.search_text = item_code
    submit_search
    fail "\nERROR: Check the 'scenario' data table for this 'feature'. The casual shirt item code is set to '#{item_code}' and cannot be found." if Capybara.current_session.current_url.include? SEARCH_NO_RESULTS_URL_IDENTIFIER
    return CasualShirtsItemDetailPage.new(@page,@country)
  end
end

module TopMenuNavigationMethods
  ##########################################################################################
  # Use the top level menu to navigate to the Home page for the given country
  ##########################################################################################
  def navigate_to_home_page(country)
    @page.find(:div_id,'menu').find(:li_class,"home prod_group").find(:link_href_has,"default").click
    #was @browser.div(:class => "nav", :id => "menu").link(:class => 'prod_group').span(:text => 'Home').fire_event("onclick")

    # wait for home page to load
    return HomePage.new(@page,country)
  end

  ##########################################################################################
  # Use the top level menu to navigate to the casual shirts page for the given country
  ##########################################################################################
  def goto_casual_shirts_product_page(country)
    case country
      when GB
        menu_href = ALL_SHIRTS_IDENTIFIER_LANG_EN; page_href = CASUAL_SHIRT_IDENTIFIER_GB
      when US
        menu_href = ALL_SHIRTS_IDENTIFIER_LANG_EN; page_href = CASUAL_SHIRT_IDENTIFIER_US
      when AU
        menu_href = ALL_SHIRTS_IDENTIFIER_LANG_EN; page_href = CASUAL_SHIRT_IDENTIFIER_AU
      when DE
        menu_href = ALL_SHIRTS_IDENTIFIER_LANG_DE; page_href = CASUAL_SHIRT_IDENTIFIER_DE
      else
        fail "ERROR: Invalid country #{country} specified in goto_casual_shirts_product_page method"
    end

    #######################################################################################################################################################
    # Click on the 'Shirts' link in the top level menu (in order to open up the menu, and therefore make the 'Casual shirts' link visible)
    # Both CSS and XPath expressions shown here FYI.
    # BEWARE THE XPATH TRAP!! You cannot 'chain' find(:xpath, expr) expressions together UNLESS you specify find(:xpath, './/expr')
    # after the initial find(:xpath, expr) expression. This applies to within(:xpath, expr) expressions too!
    #######################################################################################################################################################
    @page.find(:css, %Q(div#menu a[href*="#{menu_href}"]))
    @page.find(:xpath, %Q(//div[@id="menu"]/descendant::a[contains(@href,"#{menu_href}")]))
    #######################################################################################################################################################
    # Capybara is usually written using 'within' as it can simplify long CSS (or XPath) expressions
    #######################################################################################################################################################
    within('div#menu') do
      @page.find(:css, "a[href*='#{menu_href}']")
    end

    #######################################################################################################################################################
    # This uses a Capybara custom selector (defined in the module 'CapybaraCustomSelectors') to find any link by using its 'href' attribute as a locator
    @page.find(:div_id,'menu').find(:link_href_has,"#{menu_href}").click
    #######################################################################################################################################################

    #######################################################################################################################################################
    # The casual shirts link should be visible now. So we can locate it and then click on it.
    # (Both CSS and XPath expressions shown here FYI.)
    #######################################################################################################################################################
    if Capybara.current_driver != :selenium_chrome
      @page.find(:css, %Q(div#menu a[href*="#{page_href}"]))
      @page.find(:xpath, %Q(//div[@id="menu"]/descendant::a[contains(@href,"#{page_href}")]))

      #######################################################################################################################################################
      # (Capybara is usually written using 'within' as it can simplify long CSS (or XPath) expressions)
      #######################################################################################################################################################
      within('div#menu') do
        @page.find(:css, "a[href*='#{page_href}']")
      end

      #######################################################################################################################################################
      # This uses a Capybara custom selector (defined in the module 'CapybaraCustomSelectors') to find any link by using its 'href' attribute as a locator
      @page.find(:div_id,'menu').find(:link_href_has,"#{page_href}").click
      #######################################################################################################################################################
    end

    if Capybara.current_driver == :selenium_chrome
      @page.find(:div_id,'formal-or-casual-shirt').find(:link_href_has,"#{page_href}").click
    end
    # Casual shirts page loads
    return CasualShirtsPage.new(@page,country)
  end

  ##########################################################################################
  # Use the top level menu to navigate to the formal shirts page for the given country
  ##########################################################################################
  def goto_formal_shirts_product_page(country)
    case country
      when GB
        menu_href = ALL_SHIRTS_IDENTIFIER_LANG_EN; page_href = FORMAL_SHIRT_IDENTIFIER_GB
      when US
        menu_href = ALL_SHIRTS_IDENTIFIER_LANG_EN; page_href = FORMAL_SHIRT_IDENTIFIER_US
      when AU
        menu_href = ALL_SHIRTS_IDENTIFIER_LANG_EN; page_href = FORMAL_SHIRT_IDENTIFIER_AU
      when DE
        menu_href = ALL_SHIRTS_IDENTIFIER_LANG_DE; page_href = FORMAL_SHIRT_IDENTIFIER_DE
      else
        fail "ERROR: Invalid country #{country} specified in goto_formal_shirts_product_page method"
    end

    # Click on the 'Shirts' link in the top level menu (in order to open up the menu, and therefore make the 'formal shirts' link visible)
    @page.find(:div_id,'menu').find(:link_href_has,"#{menu_href}").click
    # The formal shirts link should be visible now. So we can locate it and then click on it.
    @page.find(:div_id,'menu').find(:link_href_has,"#{page_href}").click

    # formal shirts page loads
    return FormalShirtsPage.new(@page,country)
  end

  ##########################################################################################
  # Use the top level menu to navigate to the 'all' shirts page for the given country
  ##########################################################################################
  def goto_all_shirts_product_page(country)
    case country
      when GB || US || AU
        menu_href = VIEW_ALL_SHIRTS_LANG_EN
      when DE
        menu_href = VIEW_ALL_SHIRTS_LANG_DE
      else
        fail "ERROR: Invalid country #{country} specified in goto_all_shirts_product_page"
    end

    # Click on the 'Shirts' link in the top level menu (in order to open up the menu, and therefore make the 'formal shirts' link visible)
    @page.find(:div_id,'menu').find(:link_href_has,"#{menu_href}").click
    # The 'All shirts' link should be visible now. So we can locate it and then click on it.
    @page.find(:div_id,'menu').find_link(VIEW_ALL_SHIRTS_LANG_EN).click

    # wait for All shirts page to load
    return AllShirtsPage.new(@page,country)
  end
end

module LeftNavigationMethods
  #################################################################################################
  # Select the link on this page that matches the specified category and category value
  # (eg. category value 'L' for category type 'Fit')
  #################################################################################################
  def select_value_from_category(category_type, category_value)
    # use a hash to store the category types and the names of the corresponding 'div' element's 'id' attribute
    category_id_field = {fit: 'whats-your-fit', size: 'casual-shirt-size', collar_size: 'size', sleeve_length: sleeve_length , colour: 'your-shirt-colour', range: 'range'}
    puts "Setting '#{category_type}' to '#{category_value}'\n"

    #############################################################################################################################################################
    # Find and then click the link that matches the 'category type' and 'category_value' using Capybara's 'within' method
    # within ('div#' + %Q(#{category_id_field[category_type]})) do
    #   within ('ul.navList') do
    #     @page.has_selector?(:css, %Q(a[title="#{category_value}"])) ? "found selector" : "NOT found selector"
    #     @page.find(:css, %Q(a[title="#{category_value}"])).click
    #   end
    # end
    #############################################################################################################################################################

    #############################################################################################################################################################
    # Examples of using Jquery to click on a link, get link's attributes, or call a method upon an element
    #    @page.execute_script("$('#{selection_link}').getSetSSValue();") is an example of how to call the jquery "sytlish select" 'plugin' method getSetSSValue()
    #    @page.execute_script("$('#{selection_link}').attr('href')")
    #    @page.execute_script("$('#{selection_link}').trigger('focus')")  # trigger the 'focus' event (for that link/element). It works even though capybara's trigger()) method DOES NOT!!
    #    @page.execute_script("$('#{selection_link}').click()")   is just clicking on the element using the jquery method 'click()'
    #############################################################################################################################################################

    # build expression for locating the target link (given the 'category_type' and 'category_value'),
    target_link_locator = 'div#' + %Q(#{category_id_field[category_type]} ul.navList a[title="#{category_value}"])

    # The page may not have refreshed yet so trap any errors caused by element referencing errors (eg. StaleElementReference)
    # Note: this method will also catch 'element not found' errors and then fail the test.
    @page.trap_error { @page.find(:css, "#{target_link_locator}") }
    target_selection_link = @page.find(:css, "#{target_link_locator}")

    # click on the target link
    prev_url = Capybara.current_session.current_url
    target_selection_link.click
    fail "ERROR: Data for scenario is invalid. You're on the product detail page '#{Capybara.current_session.current_url}'" if !product_page_url_matched(@country)
    @page.trap_error { @page.find(:css, "#{target_link_locator}") }

    # Now find the link's parent element ('li') which has a 'class' attribute that tells you whether or not the checkbox is checked.
    # if the checkbox is NOT checked or the webpage url hasn't changed yet, then wait a couple of secs before clicking on the link again.
    while (@page.find(:css, "#{target_link_locator}").find(:xpath, './..')['class'] != 'checkbox selected') || (Capybara.current_session.current_url == prev_url) do
      target_selection_link.click
      puts "\nINFO: Needed to click on the '#{category_value}' link in the category '#{category_type}'\n"
      sleep 2
    end
  end

  def product_page_url_matched(country)
    q_str = '?q='
    case country
      when GB
        product_types = [CASUAL_SHIRT_IDENTIFIER_GB  + q_str, FORMAL_SHIRT_IDENTIFIER_GB + q_str, ALL_SHIRTS_IDENTIFIER_WQ_LANG_EN + q_str]
      when US
        product_types = [CASUAL_SHIRT_IDENTIFIER_US + q_str, FORMAL_SHIRT_IDENTIFIER_US + q_str, ALL_SHIRTS_IDENTIFIER_LANG_EN + q_str]
      when AU
        product_types = [CASUAL_SHIRT_IDENTIFIER_AU + q_str, FORMAL_SHIRT_IDENTIFIER_AU + q_str, ALL_SHIRTS_IDENTIFIER_LANG_EN + q_str]
      when DE
        product_types = [CASUAL_SHIRT_IDENTIFIER_DE + q_str, FORMAL_SHIRT_IDENTIFIER_DE + q_str, ALL_SHIRTS_IDENTIFIER_LANG_DE + q_str]
      else
        fail "ERROR: Invalid country #{country} specified in product_page_url_matched method"
    end

    product_types.each { |type| return TRUE if (Capybara.current_session.current_url.include? type) }
    return FALSE
  end
end


########################################################################################################################################################################
################################################ All Constants needed by MODULE CommonProductPage ######################################################################
########################################################################################################################################################################
# The indicies delimited by '|' in the (link) URL for each clothing item listed on the webpage.
INDEX_FOR_STOCK_CODE = 2
INDEX_FOR_PRICE_CODE = 5
INDEX_FOR_SIZE_CODE = 6
INDEX_FOR_OTHER_CATEGORIES = 7
INDEX_FOR_COLLAR_SIZE_CODE = 9
INDEX_FOR_SLEEVE_LENGTH = 10

################################################################################################
# The hashes below represent the category codes that are stored in the database tables
################################################################################################
FIT_LIST = { :classic => "381", :slim => "406", :extra_slim => "1861" }
COLLAR_SIZE_LIST = { :inch14_5 => "14.5", :inch15 => "15", :inch15_5 => "15.5", :inch16 => "16", :inch16_5 => "16.5", :inch17 => "17", :inch17_5 => "17.5", :inch18 => "18", :inch19 => "19", :inch20 => "20" }
SLEEVE_LENGTH_LIST = { :inch32 => "32", :inch33 => "33", :inch34 => "34", :inch35 => "35", :inch36 => "36", :inch37 => "37", :inch38 => "38" }
PRICE_LIST = { :gbp20_25 => "20 to 24.99", :gbp25_30 => "25 to 29.99", :gbp30_40 => "30 to 39.99", :gbp40_50 => "40 to 49.99", :gbp50_100 => "50 to 99.99" }
COLOUR_LIST = { :blue => "416", :green => "441", :multicolour => "456", :orange => "471", :pink => "476", :purple => "451", :reds => "481", :stone => "3606", :white => "491", :yellow => "496" }
RANGE_LIST = { :washed_oxford => "2186", :non_iron_casual => "3496", :jermyn_street_weekend => "4202", :slim_fit_oxford => "4572", :soft_twill => "3506", :summer_checks_and_stripes => "3761", :washed_favourite => "2176", :all_other_ranges => "3511" }
MATERIAL_LIST = { :pcnt100_cotton => "41", :non_iron_cotton => "1606", :linen_mix => "66" }
DESIGN_LIST = { :check => "146", :gingham_check => "3566", :plain => "221", :stripe => "236", :bengal_stripes => "unknown" }
COLLAR_TYPE_LIST = { :button_down => "4257", :classic => "4267" }
SLEEVE_TYPE_LIST = { :short_sleeve => "4392" }
CUFF_SLEEVE_LIST = { :short_sleeve => "4427" }
WEAVE_LIST = { :poplin => "427", :end_on_end => "unknown", :oxford_weave => "4537", :twill => "4227"}

# Country codes
GB = "GB"
DE = "DE"
AU = "AU"
US = "US"

FORMAL_SHIRTS = 'Formal Shirts'
CASUAL_SHIRTS = 'Casual Shirts'

# Formal Shirt Product Page URL's for each country
UK_FORMAL_PRODUCT_PAGE  = BASE_URL + "/mens-shirts/mens-formal-shirts?q=gbpdefault|||||||||||||||"
USA_FORMAL_PRODUCT_PAGE = BASE_URL + "/mens-shirts/mens-dress-shirts?q=usddefault|||||||||||||||"
AUS_FORMAL_PRODUCT_PAGE = BASE_URL + "/mens-shirts/mens-business-shirts?q=auddefault|||||||||||||||"
GER_FORMAL_PRODUCT_PAGE = BASE_URL + "/herren-hemden/herren-businesshemden?q=dmdefault|||||||||||||||"

# Casual Shirt Product Page URL's for each country
UK_CASUAL_SHIRTS_PRODUCT_PAGE  = BASE_URL + "/mens-shirts/mens-casual-shirts?q=gbpdefault|||||||||||||||"
USA_CASUAL_SHIRTS_PRODUCT_PAGE = BASE_URL + "/mens-shirts/mens-sport-and-casual-shirts?q=usddefault|||||||||||||||"
AUS_CASUAL_SHIRTS_PRODUCT_PAGE = BASE_URL + "/mens-shirts/mens-casual-shirts?q=auddefault|||||||||||||||"
GER_CASUAL_SHIRTS_PRODUCT_PAGE = BASE_URL + "/herren-hemden/herren-freizeithemden?q=dmdefault|||||||||||||||"

# Page result links
SHOW_ALL         = "Show all"
SHOW_15          = "Show 15 per page"
NEXT             = "Next"
SHOW_ALL_LANG_DE = "Alle anzeigen"
SHOW_15_LANG_DE  = "Zeige 15 pro Seite"
NEXT_LANG_DE     = "weiter"

NUMBER_OF_FIRST_ROW_ITEMS = 3

# Search Results Error Page 'SearchNoResults.aspx' name
SEARCH_RESULTS_ERROR = "SearchNoResults"

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
########################################################################################################################################################################
# MODULE CONTAINING Methods which call the page object elements defined on the Casual and Formal Shirts Product Pages
########################################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
module CommonProductPageMethods
  # Load product page dependant on country. Default country is GB.
  def visit_product_page(product_type, country)
    case
      when (country == AU) && (product_type == CASUAL_SHIRTS)
        product_page = AUS_CASUAL_SHIRTS_PRODUCT_PAGE
      when (country == AU) && (product_type == FORMAL_SHIRTS)
        product_page = AUS_FORMAL_PRODUCT_PAGE
      when (country == US) && (product_type == CASUAL_SHIRTS)
        product_page = USA_CASUAL_SHIRTS_PRODUCT_PAGE
      when (country == US) && (product_type == FORMAL_SHIRTS)
        product_page = USA_FORMAL_PRODUCT_PAGE
      when (country == DE) && (product_type == CASUAL_SHIRTS)
        product_page = GER_CASUAL_SHIRTS_PRODUCT_PAGE
      when (country == DE) && (product_type == FORMAL_SHIRTS)
        product_page = GER_FORMAL_PRODUCT_PAGE
      when (country == GB) && (product_type == CASUAL_SHIRTS)
        product_page = UK_CASUAL_SHIRTS_PRODUCT_PAGE
      when (country == GB) && (product_type == FORMAL_SHIRTS)
        product_page = UK_FORMAL_PRODUCT_PAGE
      else
        fail "INTERNAL ERROR: Country '#{country}' and/or product type '#{product_type}' are incorrectly specified in call to method 'visit_product_page'"
    end
    @page.visit product_page
  end

  # the (formal or casual) shirt product items displayed within the product listing section
  def shirt_item_links
#    wait_until_element_present (@page.find(:div_id, 'ctl00_contentBody_productListingSection').all(:link_class, 'img').first)
    @page.find(:div_id, 'ctl00_contentBody_productListingSection').all(:link_class, 'img')
  end

  # the span element that contains the links, heading and pricing information for a clothing item
  def clothing_item_container_elements
    @page.find(:div_id, 'ctl00_contentBody_productListingSection').find(:class, 'teasers')
  end

  def first_shirt_item_link
    @page.find(:div_id, 'ctl00_contentBody_productListingSection').all(:link_class, 'img').first
  end

  def shirt_item_link(product_item_code)
    @page.find(:div_id, 'ctl00_contentBody_productListingSection').find(:span_id, "#{product_item_code}").find(:link_class, 'img')
  end

  def sort_by_link(index)
    @page.find_by_id("newList_0").link(:css, 'href') ## INCOMPLETE ##
                                                     # @page.find_by_id("newList_0").link(:href => /.*/, :index => index)
  end

  # Get the item codes (SKU's) for the top row of product items
  def get_top_row_items
    top_row_items = []

    shirt_item_links.each do |link|
      item_codes_from_url = link.href.split "|"
      item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]
      top_row_items.push(item_product_code)
      break if top_row_items.length == NUMBER_OF_FIRST_ROW_ITEMS
    end
    return top_row_items
  end

  # Test if it is showing 15 product items on one page (note this is default)
  def found_show_all
    showing_all_items?
  end

  # Test if it is showing 15 product items on one page (note this is default)
  def showing_all_items?
    @country == DE ? show_15 = SHOW_15_LANG_DE : show_15 = SHOW_15_LANG_EN
    @country == DE ? show_all = SHOW_ALL_LANG_DE : show_all = SHOW_ALL_LANG_EN

    if @page.all(:div_class, 'pagination').first.has_link?("#{show_15}")
      return TRUE
    elsif @page.all(:div_class, 'pagination').first.has_link?("#{show_all}")
      return FALSE
    else
      fail "ERROR: The text '#{link_text}' on the Product Page links is incorrect. It should be 'Show All' or 'Show 15'"
    end
  end

  # Find the link to navigate to the next product page
  def found_next_product_page
    @country == DE ? show_next = 'weiter' : show_next = 'Next'

    if @page.all(:div_class, 'pagination').first.has_link?("#{show_next}") == TRUE
      return TRUE
    else
      return FALSE
    end
  end

  def select_next_product_page
    @country == DE ? show_next = 'weiter' : show_next = 'Next'

    if @page.all(:div_class, 'pagination').first.has_link?("#{show_next}")
      @page.all(:div_class, 'pagination').first.click_link("#{show_next}")
    end
  end
end


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
########################################################################################################################################################################
# MODULE CONTAINING Methods needed for the 'shortlist Minibar' on ctshirts web pages
########################################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
module Minibar
  # Elements located on the shortlist minibar (ie. related to shortlist functionality)
  def minibar
    @page.find(:div_class, 'minibar')
  end

  def minibar_header
    minibar.find(:div_class, 'minibar_header')
  end

  def minibar_products
    minibar.find(:div_class, 'minibar_prods')
  end

  def qty_in_shortlist
    minibar_header.find(:span_id, 'shotlistQty')
  end

  def view_all_items_button
    minibar_header.find(:link_href_has, 'ShortList.aspx')
  end

  def view_all_items_text_link
    minibar_products.find(:link_href_has, 'ShortList.aspx')
  end

  def view_all_items_button_image
    view_all_items_button.find(:css, 'img[src*="bt_view_my_shortlist"]')
  end

  def shortlist_item_thumbnail_link(item_code)
    minibar_products.find(:css, %Q(a[img][href*="#{item_code}"]))
  end

  def shortlist_item_thumbnail_photo(item_code)
    shortlist_item_thumbnail_link(item_code).find(:css, %Q(img[src*="#{item_code}"]))
    #shortlist_item_thumbnail_link(item_code).img(:src => /(.*)(#{item_code})(.*)\.jpg/)
  end

  def click_view_all_items_button
    view_all_items_button.when_present.click
    ShortlistPage.new(@page,@country)
  end

  def click_view_all_items_text_link
    view_all_items_text_link.click
    ShortlistPage.new(@page,@country)
  end
end


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
########################################################################################################################################################################
# MODULE CONTAINING Methods needed for lightboxes (popups) on ctshirts web pages
########################################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
module Lightboxes
  #############################################################
  # fries popup/lightbox
  #############################################################

  # fries popup dialog
  def fries_popup
    @page.find(:div_id, 'overlay_container').find(:div_class => 'fries_popup')
  end

  # fries popup 'close' link
  def close_fries_link
    fries_popup.find(:span_class, 'close').find(:link_href, '#')
  end

  # fries link that loads the page displaying the shirts in the offer
  def fries_offer_link
    fries_popup.find(:link_class => 'fries_cta')
  end

  # main paragraph in the fries dialog
  def fries_main_paragraph
    #fries_popup.p(:class => /.*/, :index => 0)
  end

  # lower paragraph in the fries dialog
  def fries_lower_paragraph
    #fries_popup.p(:class => "last")
  end

  #############################################################
  # website feedback popup
  #############################################################

  # root element of the popup
  def feedback_popup
    @page.find(:div_id => "layer_main_content")
  end

  # 'no thanks' button
  def no_thanks_button
    feedback_popup.find(:div_id, "layer_buttons").button("nothanks")
  end

  def yes_please_button
    feedback_popup.find(:div_id, "layer_buttons").button("yesplease")
  end
end


###############################################################################################################################################################################
################################################ 'Page Type' and "Currency Type" Constants needed by MODULE TeliumTags ########################################################
###############################################################################################################################################################################
PAGE_TYPE = { "Default" => 0, "Home" => 1, "AccountCredit" => 2, "AccountLogin" => 3, "AddressBook" => 4, "Basket" => 5, "Confirm" => 6, "Content" => 7, "Delivery" => 8,
"GiftVoucherEmail" => 9, "GiftVoucherPaper" =>	10, "GiftVoucherPreview" => 11, "Login" => 12, "OrderConfirmed" => 13, "OrderHistory" => 14, "OutfitDetail" => 15,
"OutfitListing" => 16, "Payment" => 17, "Preferences" => 18, "ProductCategory" => 19, "ProductDepartment" => 20, "ProductDetail" => 21, "ProductListing" => 22,
"RequestCatalogue" => 23, "Search" => 24, "SearchNoResult" => 25, "ShortList" => 26 }


COUNTRY_CURRENCY = {"GB" => "GBP", "US" => "USD", "AU" => "AUD", "DE" => "EUR"}
PROPER_ITEM_NAME_COMPARISON = TRUE
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
########################################################################################################################################################################
# MODULE CONTAINING Telium tag processing methods needed by page object classes ie. in order to read/validate the utag_data javascript embedded in all ctshirts webpages
########################################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
module TeliumTags
  def javascript_scripts
    @browser.scripts(:type => /javascript/)
  end

  def get_utag_javascript_variables(user_logged_in, page_type)
    utag_hash = {}
    tmp_array = []
    product_keywords = ['product_sku','product_name','product_unit_price','product_quantity']
    javascript_text, current_key = ''
    found_utag = FALSE
    index = 0

    #############################################################################################################################################################################
    # 'utag_var_names' array stores the names of parameters (eg. customer_email) in the utag_data javascript code. For details see Branch 1521 and Mark Kneale's email 27/07/13.
    # These parameters are used as the keys in returned 'utag_hash'.
    # Each web page type (eg. product listing, basket) can have different parameters within the utag_data code.
    #############################################################################################################################################################################
    case page_type
      when PAGE_TYPE['Home']
        if user_logged_in
          utag_var_names = ["site_currency","site_region","page_name","page_type","customer_id","customer_email","campaign_source","campaign_url_code"]
        else
          utag_var_names = ["site_currency","site_region","page_name","page_type","campaign_source","campaign_url_code"]
        end
      when PAGE_TYPE['Preferences']
        if user_logged_in
          utag_var_names = ["site_currency","site_region","page_name","page_type","customer_id","customer_email","campaign_source","campaign_url_code"]
        else
          utag_var_names = ["site_currency","site_region","page_name","page_type","campaign_source","campaign_url_code"]
        end
      when PAGE_TYPE['Basket']
        if user_logged_in
          utag_var_names = ["site_currency","site_region","page_name","page_type","customer_id","customer_email","campaign_source","campaign_url_code","product_sku","product_name","product_unit_price","product_quantity"]
        else
          utag_var_names = ["site_currency","site_region","page_name","page_type","campaign_source","campaign_url_code","product_sku","product_name","product_unit_price","product_quantity"]
        end
      when PAGE_TYPE['ProductListing']
        if user_logged_in
          utag_var_names = ["site_currency","site_region","page_name","page_type","customer_id","customer_email","campaign_source","campaign_url_code","product_sku"]
        else
          utag_var_names = ["site_currency","site_region","page_name","page_type","campaign_source","campaign_url_code","product_sku"]
        end
      when PAGE_TYPE['Search']
        if user_logged_in
          utag_var_names = ["site_currency","site_region","page_name","page_type","customer_id","customer_email","campaign_source","campaign_url_code","product_sku","site_search_keyword"]
        else
          utag_var_names = ["site_currency","site_region","page_name","page_type","campaign_source","campaign_url_code","product_sku","site_search_keyword"]
        end
      when PAGE_TYPE['SearchNoResult']
        if user_logged_in
          utag_var_names = ["site_currency","site_region","page_name","page_type","customer_id","customer_email","campaign_source","campaign_url_code","site_search_keyword"]
        else
          utag_var_names = ["site_currency","site_region","page_name","page_type","campaign_source","campaign_url_code","site_search_keyword"]
        end
      when PAGE_TYPE['OrderConfirmed']
        if user_logged_in
          utag_var_names = ["site_currency","site_region","page_name","page_type","customer_id","customer_email","customer_type","campaign_source","campaign_url_code","product_sku","product_name","order_shipping_amount","order_subtotal","order_total","order_id","order_shipping_type","product_unit_price","product_quantity","product_units","esearchvision_count","esearchvision_Basket_Items","esearchvision_event"]
        else
          utag_var_names = ["site_currency","site_region","page_name","page_type","customer_type","campaign_source","campaign_url_code","product_sku","product_name","order_shipping_amount","order_subtotal","order_total","order_id","order_shipping_type","product_unit_price","product_quantity","product_units","esearchvision_count","esearchvision_Basket_Items","esearchvision_event"]
        end
      else
        fail "INTERNAL ERROR: Page Type '#{PAGE_TYPE.key(page_type)}' / Page Number '#{page_type}' is incorrect and is not recognised by method 'get_utag_javascript_variables'"
    end

    ##########################################################################################################################
    # Find the javascript utag_data code in the current product webpage.
    ##########################################################################################################################
    javascript_scripts.each do |script|
      if script.html.include? "utag_data"
        javascript_text = script.html
        found_utag = TRUE
        break
      end
    end
    fail "ERROR: Cannot find utag_data javascript on #{PAGE_TYPE.key(page_type)} page" if !found_utag

    #########################################################################################################################################################
    # Split the utag_data code into ('\n' delimited) lines.
    # Read and process each utag_data line.
    # Add each key/value pair found to a hash (named 'utag_hash') that will store all the variables/values in the 'utag_data' javascript code.
    #########################################################################################################################################################
    js_lines = javascript_text.split "\n"
    js_lines.each do |line_text|
      puts "#{line_text}" if ENABLED_LOGGING  # helpful for debugging

      # Remove javascript formatting characters (ie. what we don't want) to clean up the line
      line = line_text.gsub('[','').gsub('{','').gsub('}','').gsub('"','').gsub(',','').strip

      # Skip to the next line if there is no key/value data here
      next if line.empty? || (line.include? 'utag_data') || (line.include? 'script')

      #########################################################################
      # Split into key and value if the ':' separator is found
      #########################################################################
      if line.include? ":"
        str = line.split ":"
        key = str[0]
        val = str[1]

        # We found one of the 'product' keys. Now skip to the next line to find the first value for this key.
        if product_keywords.include? key
          current_key = key
          next
        end

        ###############################################################################################################################################################
        # Match the key to the corresponding key stored in the 'utag_var_names' array. This match expression cleans up any other formatting characters on the line too.
        # Note any keys that are spelled incorrectly or have been added to the original specification will be ignored!
        ###############################################################################################################################################################
        if utag_var_names.include? key
          # Add the key/value pair to the hash
          val.strip! if val != nil
          utag_hash.merge!(key => val)
        end

        # Increment the index that's used to identify the key in the current 'utag_data' line
        index+=1
      else
        ###########################################################################################################################################################################################
        # There is no ':' separator in this line, therefore we must assume it's product or order related data such as item code (SKU), qty, description, price, order id, shipping total etc
        ###########################################################################################################################################################################################
        if line == ']'
          # When this line contains just a ']' this signifies the end of the product or order array. We assume all the (items) SKU's for this product or order have now been read and are stored
          # in 'tmp_array'.
          # Therefore we can write the product or order data eg. { :product_sku => [sku_1, sku_2, sku_3] } to 'utag_hash'
          utag_hash.merge!(current_key => tmp_array)
          tmp_array = []

          # Increment the index that's used to identify the key in the 'utags' array
          index+=1
        else
          # Append the value (eg. 'sku_3') to 'tmp_array' as there are still more values to be added to the array of products (or orders) eg. [sku_1, sku_2].
          tmp_array.push(line)
        end
      end
    end

    ###########################################################################################################################################################################################
    # INVALID KEYS: Fail this test if any of the keys in utag_data are additional to those expected (ie. so they are invalid)
    ###########################################################################################################################################################################################
    utag_hash.each { |key,val| puts "\nERROR: Telium tag data on 'OrderConfirmation' page. Variable '#{key}' in utag_data is unexpected" if !utag_var_names.include? key }

    ###########################################################################################################################################################################################
    # INVALID KEYS: Fail this test if any of the keys in utag_data (eg. order_shipping_amount) are missing
    ###########################################################################################################################################################################################
    utag_var_names.each { |var_name| puts "\nERROR: Telium tag data on 'OrderConfirmation' page. Variable '#{var_name}' is missing from utag_data" if !utag_hash.keys.include? var_name }

    ##############################################################################
    # return the hash containing all the utag_data variables and their values
    ##############################################################################
    return utag_hash
  end


  def get_core_page_data(customer_email_address, page_type)
    ##################################################################################################################################
    # The 'core_page_data' hash is used to store the data that the Telium tag javascript data must be compared against.
    # 'core_page_data' is to be filled with the appropriate values from the scenario data table and the current web page.
    ##################################################################################################################################
    core_page_data = {}
    core_page_data.merge!("site_currency" => COUNTRY_CURRENCY[@country])
    core_page_data.merge!("site_region" => @country)
    core_page_data.merge!("page_name" => PAGE_TYPE.key(page_type))
    core_page_data.merge!("page_type" => page_type.to_s)
    core_page_data.merge!("customer_email" => customer_email_address) if !customer_email_address.empty?

    # Campaign Source depends on Country code.
    if @country == "GB"
      core_page_data.merge!("campaign_source" => "UK+DIRECT+LOAD")
    else
      core_page_data.merge!("campaign_source" => @country + "+DIRECT+LOAD")
    end

    # Find Campaign Code from the browser url (eg. 'gbpdefault' for GB)
    case @country
      when "AU"
        @campaign_url_code = "auddefault"
      when "US"
        @campaign_url_code = "usddefault"
      when "DE"
        @campaign_url_code = "dmdefault"
      when "GB"
        @campaign_url_code = "gbpdefault"
      else
        fail "ERROR: Country has not been specified. Test Results will be unreliable, so fail this test"
    end

    core_page_data.merge!("campaign_url_code" => @campaign_url_code)
    return core_page_data
  end
end
