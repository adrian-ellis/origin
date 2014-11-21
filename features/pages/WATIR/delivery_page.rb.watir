class DeliveryPage
  # include common methods for page object classes (located in common_modules.rb)
  include CommonPageMethods
  include Waiting
  include TeliumTags

  #######################################################################
  # define page objects on the "basket" page
  #######################################################################
  def initialize(browser, country)
    @browser = browser
    @country = country
  end

  def continue_button
    @browser.button(:id => "ctl00_contentBody_submit")
  end

  def continue
    continue_button.when_present.fire_event("onclick")
  end


  def continue_to_payment_page
    prev_url = @browser.url
    continue
    wait_until_page_loaded("Payment Page", prev_url)
    return PaymentPage.new(@browser, @country)
  end
end