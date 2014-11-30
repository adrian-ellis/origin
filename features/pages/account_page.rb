class MyAccountPage
  # include common methods for page object classes (located in common_modules.rb)
  include CapybaraCustomSelectors
  include CommonPageMethods
  include Waiting
  include Lightboxes
  include TeliumTags

  #######################################################################
  # define page object methods on the "MyAccount" page
  #######################################################################

  def initialize(page,country)
    @page = page
    @country  = country
    #@my_account_link       = @browser.div(:id => 'account_nav').link(:href => /account_nav_opts/)
  end

  def page_heading_is_present
    # 'My Account' should be displayed twice. Once for a Heading, once for the link at the top of the page.
    # Use Xpath or CSS selectors to find the Heading (both work)
    xpath_expr = '//form[@id="aspnetForm"]/div[@class="first row"]/descendant::div[@class="header simple_header"]'
    css_expr = 'form#aspnetForm > div[class="first row"] div[class~="simple_header"]'
    return FALSE if @page.has_no_selector?(:css, "#{css_expr}")
    return FALSE if @page.has_no_selector?(:xpath, "#{xpath_expr}")
    return TRUE
  end

  def page_url
    Capybara.current_session.current_url
  end

  def account_link_is_present
    @page.has_link?('My account')
  end

end
