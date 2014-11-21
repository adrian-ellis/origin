class LoginPage
  # include common methods for page object classes (located in common_modules.rb)
  include CommonPageMethods
  include Waiting
  include Lightboxes
  include TeliumTags

  #######################################################################
  # define page object elements / methods on the "login" page
  #######################################################################

  def initialize(page,country)
    @page = page
    @country = country
  end

  def login_with(username, password)
    @page.fill_in('ctl00_contentBody_email', :with => "#{username}")
    @page.fill_in('ctl00_contentBody_password', :with => "#{password}")
    @page.click_on('ctl00_contentBody_submit')
  end

  def login_succeeded
    # check for an error message after making an attempt to login
    if @page.has_no_text? /(Sorry).*(things you need to correct on the form)/
      # If logging in succeeded then return a new instance of the MyAccount page
      return TRUE
    else
      return FALSE
    end
  end

  def login_failed
    # check for an error message after making an attempt to login
    if @page.has_text? /(Sorry).*(things you need to correct on the form)/
      return TRUE
    else
      return FALSE
    end
  end

  def error_message_displayed
    # check for 'div' containing login error message
    return nil if @page.has_no_selector?(:xpath, '//div[@id="ctl00_contentBody_ValidationSummary"]')

    # copy then return the error message after failed login attempt
    error_msg = @page.find(:css, 'div#ctl00_contentBody_ValidationSummary').text
    return error_msg
  end


end
