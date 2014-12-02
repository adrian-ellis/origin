require 'selenium-webdriver'
require 'capybara'
require 'capybara/cucumber'
require 'decimal'
require 'fileutils'
require 'rspec/expectations'

require 'rest_client'
require 'jsonpath'

require 'sqlite3'
require 'active_record'
#require 'logger'
#require 'database_cleaner'
#require 'factory_girl'

BASE_INSTALL_DIR = 'C:/Ruby193/ctproject'

# Set base URL to environment
NEW_QA_ENV_URL        = "http://master.silverweb.ctshirts.qa"
BASE_QA_URL           = "http://192.168.1.47"
BASE_LIVE_AUTOMATION  = "http://192.168.212.27:121"
LIVE_TEST_URL         = "http://80.64.56.153"
BASE_LIVE_URL_GB      = "http://www.ctshirts.co.uk"
BASE_LIVE_URL_US      = "http://www.ctshirts.com"
BASE_LIVE_URL_AU      = "http://www.ctshirts.com.au"
BASE_LIVE_URL_DE      = "http://www.ctshirts.de"

# set base URL to GB as default (as some tests do not consider any other countries other than GB)
BASE_URL = BASE_LIVE_URL_GB

# Basket url link is needed by all pages
BASKET_IDENTIFIER         = '/ShoppingBag.aspx'
BASKET_LINK_URL           = BASE_URL + BASKET_IDENTIFIER

# Gives the ability to change timeouts for loading pages and page elements
PAGE_TIMEOUT_SECS         = 5    # default timeout value for loading a page
PAGE_ELEMENT_TIMEOUT_SECS = 5    # default timeout value for a given page element

# Enable logging to stdout. This gives information about what the test is actually doing
# (eg. giving contents of the basket before and after removing an item)
ENABLED_LOGGING           = TRUE

# To provide more detail, this will switch logging of individual items 'on' if TRUE, and 'off' if FALSE
# (eg. outputing the SKU's and names of shirts after sorting by price has been carried out on a product page)
INDIVIDUAL_ITEM_LOGGING_ENABLED = FALSE

# set flag for determining whether or not this is the first scenario to be run (from cucumber)
ENV['FIRST_RUN'] = 'T'
PWD = Dir.pwd

require_relative '../database/active_record_classes'

##################################################################################################################
### Register a capybara browser driver eg. selenium (along with the browser type you want it to drive eg. chrome).
### So then you can use it to start a new (web browser) session, and use that execute your tests.
###
### We can also read the values of 'environment variables' set in the 'cucumber.yml' file and use them to set the
### browser type (eg. chrome) or browser configuration.
##################################################################################################################
case ENV['BROWSER']
when "chrome"
  Capybara.register_driver :selenium_chrome do
    Capybara::Selenium::Driver.new(:browser => :chrome)
  end
when "firefox"
  Capybara.register_driver :selenium_firefox do
    Capybara::Selenium::Driver.new(:browser => :firefox)
  end
when "ie"
  Capybara.register_driver :selenium_ie do
    Capybara::Selenium::Driver.new(:browser => :ie)
  end
when "none"
  # don't register a driver
  puts 'INFO: No need to open a browser\n'
else
  Capybara.register_driver :selenium_firefox do
    Capybara::Selenium::Driver.new(:browser => :firefox)
  end
end


World do
  CustomWorld.new
end

Before do |scenario|
  case ENV['BROWSER']
  when "chrome"
    Capybara.current_driver = :selenium_chrome
  when "firefox"
    Capybara.current_driver = :selenium_firefox
  when "ie"
    Capybara.current_driver = :selenium_ie
  when "none"
    # no driver needed
  else
    Capybara.current_driver = :selenium_firefox
  end

  unless ENV['BROWSER'] == "none"
    @page = page
		# clear cookies (by reseting the browser in current session)
		#Capybara.current_session.driver.browser.manage.delete_all_cookies
    Capybara.current_session.current_window.maximize if ENV['FIRST_RUN'] == 'T'
  end

  # create 'logs' directory if needed. Then create a log file (whose name is based on the scenario and timestamp) in thia directory
  Dir.mkdir("logs") unless File.directory?("logs")
	ENV['LOGFILE'] = %Q(logs/#{scenario_name(scenario)}.log)
	File.new(ENV['LOGFILE'], 'w')

  # Determine if the current scenario's website 'country' is 'GB'
  ENV['CURRENT_COUNTRY'] = scenario_country(scenario)
end

After do |scenario|
  # set flag to FALSE ('F') as the first scenario has now been run
  ENV['FIRST_RUN'] = 'F'

  record_results = TRUE
  if scenario.failed? && record_results
    # create directory to store screenshots if needed. Then store the screenshot (whose name is based on the scenario and timestamp) in the 'screenshots' directory
    Dir.mkdir("screenshots") unless File.directory?("screenshots")
    scenario_file_name = scenario_name(scenario)
    page.save_screenshot("screenshots/#{scenario_file_name}.png")

    # determine whether scenario is a scenario outline, then embed the screenshot with label name based on scenario name or example row.
    scenario_has_examples?(scenario) ? label = "Screenshot for Example: #{example(scenario)}" : label = "Scenario Screenshot"
    embed("screenshots/#{scenario_file_name}.png", 'image/png', label)

		# create 'results' directory if needed. Then copy the results file to thia directory
    Dir.mkdir("results") unless File.directory?("results")
    FileUtils.copy('results.html', "results/#{scenario_file_name}.html")
  end

  unless ENV['BROWSER'] == "none"
    Capybara.current_session.reset! if (Capybara.current_session != nil)
  end
end

at_exit do
  # we need to close the browser after all scenarios have been run
  puts "at exit\n"
  unless ENV['BROWSER'] == "none"
    Capybara.current_session.driver.browser.close if (Capybara.current_session != nil)
  end
end