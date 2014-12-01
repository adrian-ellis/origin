class HomePage
  # include common methods for page object classes (located in common_modules.rb)
  include Capybara::DSL
  include CapybaraCustomSelectors
  include CommonPageMethods
  include Waiting
  include TeliumTags

  #######################################################################
  # Load the "Home" page
  #######################################################################
  def initialize(page,country)
    @page = page
    @country = country
    @popups_last_link = %Q(div#country-popup div.pick-another a[href*="/Country/Change/"])  # css expr for the last *set* of links in the change country lightbox
    @popup = 'div#country-popup'  # css expr for the change country we must click on
    @popups_change_country_link = %Q(div#country-popup a[href="/Country/Change/#{@country}"])  # css expr for the change country we must click on
    @country_code = {'GB' => ["#{BASE_LIVE_URL_GB}", 'gbp'], 'US' => ["#{BASE_LIVE_URL_US}", 'usd'], 'AU' => ["#{BASE_LIVE_URL_AU}", 'aud'], 'DE' => ["#{BASE_LIVE_URL_DE}", 'dm']}
    @counter = 0
    fail "ERROR: Invalid country \'#{@country}\' specified when attempting to load home page." if !@country_code.has_key?(@country)

    # Load the Home page for the given country when a new instance of this 'page object' is created (if it's not already loaded).
    # We do this here because, it's possible to load the Home page from the top level menus on most other ctshirts website pages.
    # (It was @uk_home_page = BASE_LIVE_URL_GB + "/default.aspx?q=gbpdefault|||||||||||||||" for GB previously)
    # @home_page_url = @country_code[@country][0] + '/default.aspx?q=' + @country_code[@country][1] + 'default|||||||||||||||'
    @home_page_url = @country_code[@country][0]
    ensure_on_homepage
  end

  ########################################################################################################################################################
  # Ensure that the homepage (for the specified country's URL) is loaded. If it needs loading, check for the existence of the 'country selection' lightbox
  ########################################################################################################################################################
  def ensure_on_homepage
    if !Capybara.current_session.current_url.include? @home_page_url
      @page.visit(@home_page_url)

      # sometimes the sever rejects the browser request and the search error page is displayed. Fail the test if this scenario occurs.
      fail "ERROR: Server has rejected browser's request. Search Results Error Page has loaded instead." if Capybara.current_session.current_url.include? 'SearchNoResults'

      # If the 'Your Location' lightbox appears because we loaded a different country's website (ie. not GB), select the country link from the lightbox,
      # and wait for the page to load
      # NOTE: DOESNT WORK IN 'IE' AS div(:id => 'country-popup') contains a reference to a JQuery that needs to run instead of a link to click on !!!!!
      if ENV['CURRENT_COUNTRY'] != 'GB'
        wait_until_has_selector(@popup)
        @page.all(@popups_change_country_link).first.click
        wait_until_has_no_selector(@popup)
      end
    end
  end

  #####################################################################################
  # load the change country lightbox (this causes problems in some browsers eg. chrome)
  #####################################################################################
  def load_change_country_lightbox
    @page.click_link('ctl00_contentFooter_ctlMegaFooter_ChangeCountry')
    wait_until_has_selector(@popup)
  end

  ############################################################
  # close the survey popup
  ############################################################
  def close_popup
    if @page.has_selector?(:div_id, "layer_main_content")
      @counter+=1

      # click the no thanks button if it's displayed
      if @page.has_selector?(:css, 'input[id="nothanks"]')
        @page.find(:css, 'input[id="nothanks"]').click
        puts "#{@counter}: CLICKED ON no thanks BUTTON\n"
      else
        puts "#{@counter}: CANT FIND no thanks BUTTON\n"
      end
    end
  end

  def visit_loginpage
    @page.click_link 'Log in'
    return LoginPage.new(@page,@country)
  end

  def style_hints_and_tips_heading
    #@browser.link(:href => /Style-tips-and-hints/) shows href
    @page.click_link 'See all hints and tips'
  end  
  
  def buy_the_outfit_link
    #@browser.link(:href => /Outfitlisting.aspx/) shows href
    @page.click_link 'Buy the outfit'
  end
end
