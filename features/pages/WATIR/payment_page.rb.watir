VISA_CARD_NUMBER                = "4111111111111111"
VISA_CARD_NAME                  = "DO NOT SHIP"
VISA_CARD_SECURITY_NUMBER       = "111"
VISA_CARD_MONTH                 = "04"
VISA_CARD_YEAR                  = "2014"
PAYMENT_NOT_ACCEPTED            = FALSE
SUBMIT_VISA_PAYMENT_REPETITIONS = 3
ORDER_CONFIRM_PAGE_PARTIAL_URL  = 'orderConfirmed.aspx'

class PaymentPage
  # include common methods for page object classes (located in common_modules.rb)
  include CommonPageMethods
  include Waiting
  include TeliumTags

  #######################################################################
  # define page objects on the "basket" page
  #######################################################################
  def initialize(browser,country)
    @browser = browser
    @country = country
  end

  def card_name
    @browser.text_field(:id => "card_name")
  end

  def card_number
    @browser.text_field(:id => "card_number")
  end

  def card_security_number
    @browser.text_field(:id => "card_security_number")
  end

  def save_address_button
    @browser.button(:id => "ctl00_contentBody_SaveAddress")
  end

  def secure_payment_button
    @browser.button(:id => "submit")
  end

  def payment_failed
    @browser.div(:id => "ctl00_contentBody_errorNotice").h2(:text => /unable to authorise/).exists?
  end

  ##########################################################
  # Utility methods and other methods calling page object elements
  ##########################################################
  def select_visa
    @browser.radio(:id => "ctl00_contentBody_card_visa").set
  end

  def card_number=(number)
    @browser.text_field(:id => "card_number").set(number)
  end

  def card_number_is_correct
    card_number.value == VISA_CARD_NUMBER
  end

  def card_name=(name)
    @browser.text_field(:id => "card_name").set(name)
  end

  def card_name_is_correct
    card_name.value == VISA_CARD_NAME
  end

  def card_security_number=(number)
    @browser.text_field(:id => "card_security_number").set(number)
  end

  def card_security_number_is_correct
    card_security_number.value == VISA_CARD_SECURITY_NUMBER
  end

  # Set VISA card expiry month
  def expiry_month=(month)
    @browser.execute_script("$('#ECOM_CARDINFO_EXPDATE_MONTH').getSetSSValue('#{month}');")
  end

  # Confirm the VISA card expiry month is set correctly (to VISA_CARD_MONTH (eg. '04'))
  def expiry_month_selection_is_correct
    @browser.select(:id => "ECOM_CARDINFO_EXPDATE_MONTH").option(:value => VISA_CARD_MONTH).selected?
  end

  # Set VISA card expiry year
  def expiry_year=(year)
    @browser.execute_script("$('#ECOM_CARDINFO_EXPDATE_YEAR').getSetSSValue('#{year}');")
  end

  # Confirm the VISA card expiry year is set correctly (to VISA_CARD_YEAR (eg. '2014'))
  def expiry_year_selection_is_correct
    @browser.select(:id => "ECOM_CARDINFO_EXPDATE_YEAR").option(:value => VISA_CARD_YEAR).selected?
  end

  ################################################################################################
  # Complete the payment by entering all the details needed when paying by VISA card
  ################################################################################################
  def pay_by_visa
    # Before we can process the payment we are prompted to save the delivery address.
    save_address_button.when_present.click
    wait_until_element_present(card_name)

    # Select VISA payment method and enter the card details
    select_visa
    self.card_number = VISA_CARD_NUMBER
    self.card_name = VISA_CARD_NAME
    self.card_security_number = VISA_CARD_SECURITY_NUMBER
    self.expiry_month = VISA_CARD_MONTH
    self.expiry_year = VISA_CARD_YEAR

    # Check that all the card details have been set correctly
    fail "ERROR: VISA Card Number entered '#{card_number.value}' is incorrect. It should be '#{VISA_CARD_NUMBER}'" if !card_number_is_correct
    fail "ERROR: VISA Card Name entered '#{card_name.value}' is incorrect. It should be '#{VISA_CARD_NAME}'" if !card_name_is_correct
    fail "ERROR: VISA Card Security Number entered '#{card_security_number.value}' is incorrect. It should be '#{VISA_CARD_SECURITY_NUMBER}'" if !card_security_number_is_correct
    fail "ERROR: VISA Card Expiry Month entered is incorrect. It should be '#{VISA_CARD_MONTH}'" if !expiry_month_selection_is_correct
    fail "ERROR: VISA Card Expiry Year entered is incorrect. It should be '#{VISA_CARD_YEAR}'" if !expiry_year_selection_is_correct

    # submit the payment
    secure_payment_button.click

    # Wait until either of the following occur :-
    #   1) the page URL changes to that of the Order Confirmation Page
    #   2) the payment failed message is displayed (when the Payment Page reloads)
    # If neither happens before PAGE_TIMEOUT_SECS is reached then fail this test.
    prev_url = @browser.url
    time_secs = 0
    while time_secs < PAGE_TIMEOUT_SECS
      break if @browser.url.include? ORDER_CONFIRM_PAGE_PARTIAL_URL
      break if (@browser.url == prev_url) && payment_failed
      sleep 1
      time_secs+=1
      fail "ERROR: Order Confirmation Page in country '#{@country}' failed to load, and no 'Payment failure' message was displayed even after waiting #{PAGE_TIMEOUT_SECS} secs" if time_secs == PAGE_TIMEOUT_SECS
    end

    return PAYMENT_NOT_ACCEPTED if payment_failed

    # Return the new instance of OrderConfirmationPage
    return OrderConfirmationPage.new(@browser, @country)
  end
end