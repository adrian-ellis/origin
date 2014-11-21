require "#{Dir.pwd}/features/lib/common_modules"

# the most common casual shirt size options
ALL_CASUAL_SHIRT_SIZES = ["S","M","L","XL","XXL"]

# The default casual shirt size to be selected if no size is specified in the Scenario data table
DEFAULT_SIZE = "L"

PROMPT_TO_SELECT_LANG_EN = 'please select'
PROMPT_TO_SELECT_LANG_DE = /bitte w.hlen/

# Return code for the case where the value in the 'Size' select box cannot be found
CONTENTS_NOT_FOUND = FALSE

class CasualShirtsItemDetailPage
  # include common methods for page object classes (located in common_modules.rb)
  include Capybara::DSL
  include CapybaraCustomSelectors
  include WaitForAjax
  include Waiting
  include CommonPageMethods
  include Minibar
  include TopMenuNavigationMethods

  #######################################################################
  # define page objects on the casual shirts product page
  #######################################################################
  def initialize(page, country)
    @page = page
    @country = country
  end

  def main_content
    @page.find(:div_id, 'content')
  end

  # Element that contains the user controls on this page eg. 'size' selection box
  def main_controls_section
    @page.find(:span_id, 'ctl00_contentBody_ctl02_instock')
  end

  ####################################################################################
  # 'size' related methods
  ####################################################################################

  # 'Size' selection box link. This link controls the opening of the selection box.
  def shirt_size_select_box
    main_controls_section.find(:link_href_has, 'shoe_size')
  end

  # find the currently selected value within the 'size' select box
  def shirt_size_select_box_value
    shirt_size_select_box.all(:css, '*').each do |element|
      return element.text.strip if (element.tag_name == "strong")
    end
    return CONTENTS_NOT_FOUND
  end

  # 'Size' div section where the links that select each size value (eg. S, M) are found.
  # find all the 'size' links on the page
  def find_all_sizes
    @page.all(:css, 'div#shoe_size a')
  end

  # The first shirt size link.
  def first_shirt_size
    @page.all(:css, 'div#shoe_size a').first
  end

  ####################################################################################
  # 'quantity' related methods
  ####################################################################################
  def quantity=(value)
    @page.execute_script("$('select#quantity').getSetSSValue('#{value}');")
  end

  ####################################################################################
  # define methods to call the page objects we have defined on the casual shirts page
  ####################################################################################

  # click add to basket button
  def add_to_basket
    @page.click_button("ctl00_contentBody_ctl02_submit")
  end

  def open_shirt_size_select_box
    shirt_size_select_box.click if self.size_box_is_closed
  end

  def close_shirt_size_select_box
    shirt_size_select_box.click if self.size_box_is_open
  end

  def size_box_is_open
    @page.has_selector?(:css, 'div#shoe_size[class*="open"]')
  end

  def size_box_is_closed
    @page.has_selector?(:css, 'div#shoe_size[class*="closed"]', :visible => FALSE)
  end

  def size_highlighted_in_red
    main_controls_section.has_selector?(:css, '*[class*="has_errors"]')
  end

  # Find the contents of the 'Size' selection box (these are actually links under a 'div' with an 'id' of "shoe_size"!)
  # verify the sizes are the same single character codes as defined in ALL_CASUAL_SHIRT_SIZES, and whether they include the
  # 'order' or 'stock' keywords too. Store the sizes in an array 'shirt_sizes' to help comparisons.
  def find_all_shirt_sizes
    shirt_sizes = []

    # Open 'size' select box if it has not already been opened (by the step definition code for the current scenario).
    open_shirt_size_select_box

    # Wait for the first link to be present before looping through the 'size' links.
    wait_until_element_present { @page.has_selector?(:css, %Q(div#shoe_size[class*="open"] a)) }

    link_expr = %q(//div[@id="shoe_size"]//a[text()="S " or text()="M " or text()="L " or text()="XL " or text()="XXL "])
    @page.all(:xpath, link_expr).each do |link|
      shirt_sizes << link.text.strip
    end
    return shirt_sizes
  end

  # Link used to select the value in the 'Size' selection box. Which link is selected
  # depends on the index value provided (eg. 0, 1, 2).
  def shirt_size_by_index(index)
    wait_until_element_present { @page.has_selector?(:css, %Q(div#shoe_size[class*="open"] a)) }
    @page.all(:css, 'div#shoe_size[class*="open"] a')[index].click
  end

  # Link used to select the value in the 'Size' selection box. Which value is selected
  # depends on the value provided (eg. "S", "L", "XL").
  def set_shirt_size_value(value)
    value_found = FALSE
    wait_until_element_present { @page.has_selector?(:css, %Q(div#shoe_size[class*="open"] a)) }

    # Ignore out any other text apart from the actual size itself (eg. 'XXL Order now, stock due 03/08/2013')
    # But we have to add a space to the text we expect to find. ie. 'XXL' is really 'XXL '
    @size_value = value + ' '
    link = %Q(//div[@id="shoe_size"]//a[text()="#{@size_value}"])
    if @page.has_selector?(:xpath, link)
      @page.find(:xpath, link).click
      value_found = TRUE
    end
    return value_found
  end
end


