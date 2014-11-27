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

# A switch that is used to redirect all calls to the Casual Shirts product page
# to use the All Shirts product page instead
# (ie. as there may just be a Casual shirts 'Department page' that does not list individual shirts)
NO_CASUAL_SHIRTS_PRODUCT_LISTING_PAGE = FALSE

############################################################################################################################
# Require the file that contains the EnvMethods module. Then 'extend' the World object (whose scope is per current scenario) to include this module.
# This module contains methods used to create screen dumps # and save test results to files in appropriately named subdirectories
############################################################################################################################
# NOTE: All Step Definitions will run in the context of the current World instance. (A new instance is created for each scenario).
# This means that self in a Step Definition block will be the World instance. Any @instance_variable instantiated in a Step Definition
# will be assigned to the World, and can be accessed from other Step Definitions.
############################################################################################################################
puts "current dir is #{Dir.pwd}\n"
require_relative '../lib/common_modules'
require_relative '../database/active_record_classes'
#World(Capybara::DSL, EnvMethods, BooleanExpectations)

# Instead of including methods from modules (eg. EnvMethods) so we can use these methods (eg. scenario_name) within the World object,
# We can create an instance of CustomWorld (class). This is very powerful!! We can now use any methods (included from other Modules too!),
# or variables within this Class instance *in any step definition*
#-----------------------------------------------------------------------------------------------------------------------------------------------------
######################################################################################################################################################
# MODULE CONTAINING Methods used for accessing hash keys
######################################################################################################################################################
#-----------------------------------------------------------------------------------------------------------------------------------------------------
class Hash
  def has_key_like?(arg)
    self.select do |key, value|
      return TRUE if (key.downcase.include? arg)
    end
    return FALSE
  end

  def value_for_key_like(arg)
    result = []
    self.select do |key, value|
      result = value if (key.downcase.include? arg)
    end
    return result
  end
end



##################################################################################################################
### Register a capybara browser driver eg. selenium (along with the browser type you want it to drive eg. chrome).
### So then you can use it to start a new (web browser) session, and use that execute your tests.
###
### We can also read the values of 'environment variables' set in the 'cucumber.yml' file and use them to set the
### browser type (eg. chrome) or browser configuration.
##################################################################################################################
case ENV['BROWSER']
when "chrome"
  Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
when "firefox"
  Capybara.register_driver :selenium_firefox do |app|
    Capybara::Selenium::Driver.new(app, :browser => :firefox)
  end
when "ie"
  Capybara.register_driver :selenium_ie do |app|
    Capybara::Selenium::Driver.new(app, :browser => :ie)
  end
when "none"
  # don't register a driver
  puts 'INFO: No need to open a browser\n'
else
  Capybara.register_driver :selenium_firefox do |app|
    Capybara::Selenium::Driver.new(app, :browser => :firefox)
  end
end

#Capybara.default_wait_time=10

# Create a custom world (class) and create an new instance of this class.
# This is an alternative to extending 'World' to include just the modules we want to use.
World do
  CustomWorld.new
end

##################################
#def register_driver(name, &block)
#  drivers[name] = block
#end
#def drivers
#  @drivers ||= {}
#end
######################################################
# So @drivers gives you a list of drivers you can run.
######################################################

#Capybara.current_driver = :selenium_firefox
#session = Capybara.current_session
#session = Capybara::Session.new(:selenium_firefox)
##################################

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
		Capybara.current_session.reset!
    Capybara.current_session.current_window.maximize
  end

  # create 'logs' directory if needed. Then create a log file (whose name is based on the scenario and timestamp) in thia directory
  Dir.mkdir("logs") unless File.directory?("logs")
	LOGFILE = %Q(logs/#{scenario_name(scenario)}.log)
	File.new(LOGFILE, 'w')
end

After do |scenario|
  record_results = TRUE
  if scenario.failed? && record_results
    # create directory to store screenshots if needed. Then store the screenshot (whose name is based on the scenario and timestamp) in the 'screenshots' directory
    Dir.mkdir("screenshots") unless File.directory?("screenshots")
    file_name_png = scenario_name(scenario) + '.png'
    page.save_screenshot("screenshots/#{file_name_png}")

    # attach a screenshot to the results file defined in the cucumber profile (inside the cucumber.yml file)
    embed("screenshots/#{file_name_png}", 'image/png','screenshot')

		# create 'results' directory if needed. Then copy the results file (whose name is based on the scenario and timestamp) to thia directory
    Dir.mkdir("results") unless File.directory?("results")
    file_name_html = scenario_name(scenario) + '.html'
    FileUtils.copy('results.html', "results/#{file_name_html}")
	end
end

at_exit do
  # we need to close the browser after all scenarios have been run
  puts "at exit\n"
  unless ENV['BROWSER'] == "none"
    Capybara.current_session.driver.browser.close if (Capybara.current_session != nil)
  end
end