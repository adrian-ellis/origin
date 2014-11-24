require_relative '../lib/common_modules'

class CustomWorld
  include Capybara::DSL
  include CapybaraCustomSelectors
  include BooleanExpectations
  include EnvMethods
	include LogToFile
  include JsonDataQuerying
  include Waiting

  def initialize
    @current_browser = ENV['BROWSER']  # the current browser type that's running
    @country = GB     # set the default value to GB (NOTE: some methods assume 'country' is a global variable, when it should be passed in as a method argument)
    @response = nil
  end

  #################################################################################################################################
  # Note: javascript functions (event listeners) using event.preventDefault stop the default action (for the event) being triggered
  #################################################################################################################################
  def trigger_event(element,event)
    # note: make sure the browser has loaded jquery into its cache, or you can't use jquery api's
    page.evaluate_script("$('#{element}').trigger('#{event}')")
  end

  def get_attr(element,arg)
    page.evaluate_script("$('#{element}').attr('#{arg}')")
  end

  # For this element, set css styling property 'name' to 'val' (eg. display = none, display = block, display = inline)
  def set_css(element,name,val)
    page.evaluate_script("$('#{element}').css('#{name}','#{val}')")
  end
end
