# set to some default values
MG_FONT = 'sports script'
MG_COLOUR = 'black'
MG_INITIALS = 'HHR'
MG_POSITION = 'cuff above watch'

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
    @current_page_type
    @current_page_instance
    @routes = {:add_monogram =>   [['HomePage','search_for_formal_shirt','SN112SKY'],
                                  ['FormalShirtsItemDetailPage','check_add_monogram']] }
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

  ########### USEFUL FOR FINDING OUT WHICH METHODS RETURN ANYTHING USEFUL ###########
  #  scenario_outline_public_methods = scenario.scenario_outline.public_methods
  #  puts scenario_outline_public_methods
  #  all_methods = scenario_outline_public_methods
  #    all_methods.each do |meth|
  #      begin
  #        ret = eval(%Q(scenario.scenario_outline.#{meth}))
  #        puts "\n\n#{meth} works OK. Output is ...\n#{ret}" if ret != nil
  #      rescue Exception
  #      end
  #    end
  ###################################################################################

  # HOW TO MAKE THIS WORK?
  # If you plan to use the navigate_to method you will need to ensure
  # you setup the possible routes ahead of time. You must always have
  # a default route in order for this to work. Here is an example of
  # how you define routes:
  #
  # @example Example routes defined in env.rb
  # PageObject::PageFactory.routes = {
  # :default => [[PageOne,:method1], [PageTwoA,:method2], [PageThree,:method3]],
  # :another_route => [[PageOne,:method1, "arg1"], [PageTwoB,:method2b], [PageThree,:method3]]
  # }
  #
  # Notice the first entry of :another_route is passing an argument
  # to the method.

  # Enable a method call on any Page Object
  def on(page_class)
    if !@current_page_instance.instance_of?(page_class)
      @current_page_instance = page_class.new(@page,@country)
      @current_page_type = page_class
    end
    return @current_page_instance
  end

  def goto_monogram(product_item_code)
    on(HomePage).search_for_formal_shirt(product_item_code)
    on(FormalShirtsItemDetailPage).check_add_monogram
  end

  # As an experiment, do everything needed to create a monogram on a shirt from scratch (for any given country)
  def add_monogram(product_item_code, country)
    @country = country

    goto_monogram(product_item_code)
    on(FormalShirtsItemDetailPage).mg_font = MG_FONT.downcase
    on(FormalShirtsItemDetailPage).mg_colour = MG_COLOUR.downcase
    on(FormalShirtsItemDetailPage).mg_position = MG_POSITION.downcase
    on(FormalShirtsItemDetailPage).mg_initials = MG_INITIALS
    on(FormalShirtsItemDetailPage).confirm_add_monogram

    # verify mg box is checked
    expect(on(FormalShirtsItemDetailPage).add_monogram_checked?).to be(TRUE)

    # identify the font, color, position and initials from the mg description label
    mg_description = on(FormalShirtsItemDetailPage).monogram_description
    mg_selection = on(FormalShirtsItemDetailPage).get_monogram_selections(mg_description)

    # verify the assertions are correct
    expect(MG_FONT.downcase).to eq(mg_selection[:font].downcase)
    expect(MG_COLOUR.downcase).to eq(mg_selection[:color].downcase)
    expect(MG_INITIALS.downcase).to eq(mg_selection[:initials].downcase)
    if (@country != 'DE')
      expect(MG_POSITION.downcase).to eq(mg_selection[:position].downcase)
    else
      expect(ALL_MG_POSITIONS_DE[position].downcase).to eq(mg_selection[:position].sub(/.ber/,'uber').downcase)
    end
  end
end
