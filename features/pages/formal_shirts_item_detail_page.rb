require "#{Dir.pwd}/features/lib/common_modules"

#INCHES = "inches"
#CM = "cm"
NONE = "none"
ERROR = "error"

class FormalShirtsItemDetailPage
  # include common methods for page object classes (located in common_modules.rb)
  include Capybara::DSL
  include CapybaraCustomSelectors
  include BooleanExpectations
	include LogToFile
  include WaitForAjax
  include Waiting
  include CommonPageMethods
  include Minibar
  include TopMenuNavigationMethods

  #-----------------------------------------------------------------------------------
  ####################################################################################
  # define page object elements on the formal shirts product page
  ####################################################################################
  #-----------------------------------------------------------------------------------
  def initialize(page, country)
    @page = page
    @country = country
    @mtc_href_identifier   = 'TieCufflinkMatcher'
  end

  # Element that contains the user controls on this page eg. 'size' selection box
  def main_controls_section
    @page.find(:span_id, 'ctl00_contentBody_ctl02_instock')
  end

  def mtc_link
    @page.find(:link_href_has, "#{@mtc_href_identifier}")
  end

  def mtc_lightbox
    @page.find(:div_id, "tie_cufflink_matcher")
  end

  def add_to_basket
    @page.click_button('ctl00_contentBody_ctl02_submit')
  end

  def add_to_shortlist
    @page.find(:link_class, "shortlist_action add")
  end

  ####################################################################################
  # quantity related methods
  ####################################################################################
  def quantity
    @page.evaluate_script("$('select#quantity').getSetSSValue();")
  end

  def quantity=(value)
    @page.execute_script("$('select#quantity').getSetSSValue('#{value}');")
  end

  ####################################################################################
  # sleeve length related methods
  ####################################################################################
  # sleeve length selection box
  def sleeve_length_select_box
    @page.find(:link_href_has, 'sleeve_length')
  end

  # sleeve length fieldset which contains the selection box.
  # It determines whether or not the selection box is highlighted in red
  def sleeve_length_fieldset
    @page.find(:css, 'fieldset[class*="sleeve_length"]')
  end

  def sleeve_length_select_box_value
    sleeve_length_select_box.all(:css, '*').each do |element|
      return element.text.sub('"','') if (element.tag_name == "strong")
    end
    return ERROR
  end

  def sleeve_length_box_is_open
    @page.has_selector?('div#sleeve_length[class*="open"]')
  end

  def sleeve_length_box_is_closed
    @page.has_selector?('div#sleeve_length[class*="closed"]', :visible => FALSE)
  end

  def all_sleeve_length_links
    @page.all(:css, 'div#sleeve_length[class*="open"] a')
  end

  # select value in sleeve length selection box by index
  def set_sleeve_length_by_index(index)
    wait_until_element_present { @page.has_selector?(%Q(div#sleeve_length[class*="open"] a)) }
    @page.all(:css, 'div#sleeve_length[class*="open"] a')[index].click
  end

  # select value in sleeve length selection box by index
  def sleeve_length_link(value)
    @page.all(:css, %Q(div#sleeve_length[class*="open"] a[href=#{value}]))
  end

  def first_sleeve_length_link
    @page.all(:css, 'div#sleeve_length[class*="open"] a').first
  end

  # data table that contains all standard and custom sleeve length information, measurements and pricing
  def sleeve_length_data_table
    @page.find(:css, 'div#sleeve_length[class*="open"] dl[id="customLength"]')
  end

  def open_sleeve_length_select_box
    sleeve_length_select_box.click unless self.sleeve_length_box_is_open
  end

  def sleeve_length_highlighted_in_red
    main_controls_section.has_selector?(:css, '*[class*="sleeve_length"][class*="has_errors"]')
  end

  def get_all_sleeve_lengths
    ###############################################################################################################################################
    # Create hash @slv_table_values where the 'key' is the actual length in inches, and 'val' is the code needed to select the
    # link within the 'div' table.
    # These links can only be identified by their 'href' attribute. In the href there is a '#' followed by the actual sleeve length code
    # (eg. 33|1), which is the part we need.
    # Note that the 'dd' elements with class "lenOp" contain all the child elements needed to build the hash @slv_table_values.
    ###############################################################################################################################################
    slv_table_values = {}
    # The method 'open_sleeve_length_select_box' MUST be called before attempting to set the sleeve length value.
    # Wait for the sleeve length links (inside the 'sleeve_length' div) to appear.
    wait_until_element_present { @page.has_selector?('div#sleeve_length[class*="open"] a') }

    sleeve_length_data_table.all('dd.lenOp').each do |element|
      # Each 'dd' element should have a child 'link' element. This link has the 'href' attribute, we use as the 'key'.
      slv_str = element.find('a[href]')['href'].split '#'
      slv_code = '#' + slv_str[1]

      # Each 'dd' element should have a child 'span' element. This 'span' text contains the sleeve length value in inches. We use this as the 'val'.
      slv_value = element.find(:span_class, 'size').text.sub('"','')
      slv_table_values.merge!(slv_value => slv_code)
    end
    return slv_table_values
  end

  #####################################################################################################################################################################
  # Set the value in sleeve length selection box. This is done by clicking on a link within a table which is located within a 'div' with the id of 'sleeve_length'.   #
  # This link is found by matching the link 'href' attribute (to 'size_option_code').                                                                                 #
  #####################################################################################################################################################################
  # IMPORTANT NOTE: Attempting to click on this link before the 'div' is open/visible (and the table elements accessible) will cause an exception and fail this test! #
  #####################################################################################################################################################################
  def set_sleeve_length_value(size_option_code)
    # size_option_code (eg. "33|7") matches the tail part of the 'href' attribute of the link we want to click (eg. '#33\|7')
    @size_option_code = size_option_code
    log("Setting Sleeve length to '#{@size_option_code}'\n") if ENABLED_LOGGING

    # Wait for the elements (specifically the link whose 'href' attribute matches size_option_code) in the data table to become present.
    # Then click on that link, to set the sleeve length value.
    wait_until_element_present { @page.has_selector?(%Q(div#sleeve_length[class*="open"] a[href$="#{@size_option_code}"])) }
    @page.find(%Q(div#sleeve_length[class*="open"] a[href$="#{@size_option_code}"])).click
		
		# If clicking on the link did not close the select box then wait 1 second and try clicking again. 
		# Try this up to 3 times. If it's still open after doing this, then the test will fail on next statement outside this loop.
		counter=0
		while @page.has_selector?(%Q(div#sleeve_length[class*="open"])) do
			break if counter > 2
			@page.find(%Q(div#sleeve_length[class*="open"] a[href$="#{@size_option_code}"])).click
			sleep 1
			counter+=1
		end
		
		# Wait until the select box is closed.
    wait_until_element_present { @page.has_selector?(%Q(div#sleeve_length[class*="closed"]), :visible => FALSE) }
  end

  # If the link used to set the target sleeve length is located BELOW the 'dt' element marker (for custom sleeve length),
  # then the sleeve length is a custom length.
  def is_a_custom_sleeve_length(size_option_code)
    count = 0
    target_element_index = 0
    info_element_index = 0
    @size_option_code = size_option_code

    # Search the 'dd' and 'dt' elements in this data table for information
    sleeve_length_data_table.all('.lenOp').each do |element|
      # The 'dd' element should have a child element 'span'. The 'span' text contains the sleeve length value in inches
      if element.tag_name == "dd"
        # Found the sleeve length link that matches the currently selected sleeve length value 'size_option_code' (eg. 33|8)
        slv_str = element.find('a[href]')['href'].split '#'
        slv_code = '#' + slv_str[1]
        target_element_index = count if slv_code == @size_option_code
      elsif element.tag_name == "dt" && element.has_selector?('span.cost')
        # The 'dt' element we are searching for should have a child element 'span' with class 'meta cost'.
        # The remaining 'dd' elements in this data table should all relate to custom sleeve lengths.
        info_element_index = count
      end
      count+=1
    end

    return TRUE if target_element_index > info_element_index
    return FALSE
  end

  ####################################################################################
  # collar size related methods
  ####################################################################################
  # collar size election box
  def collar_size_select_box
    @page.find(:link_href_has, 'collar_size')
  end

  def collar_size_section
    @page.find(:div_id, 'collar_size')
  end

  def all_collar_size_links
    @page.find(:div_id, 'collar_size').all(:css, 'a')
  end

  # sleeve length fieldset which contains the selection box.
  # It determines whether or not the selection box is highlighted in red
  def collar_size_fieldset
    @page.find(:css, 'fieldset[class*="collar_size"]')
  end

  # find collar size link by index
  def collar_size_by_index(index)
    @page.find(:div_id, 'collar_size').all(:css, 'a')[index]
  end

  def first_collar_size_link
    @page.find(:div_id, 'collar_size').all(:css, 'a').first
  end

  def open_collar_size_select_box
    collar_size_select_box.click if self.collar_size_box_is_closed
  end

  def close_collar_size_select_box
    collar_size_select_box.click if self.collar_size_box_is_open
  end

  def collar_size_box_is_open
    @page.has_selector?(:css, 'div#collar_size[class*="open"]')
  end

  def collar_size_box_is_closed
    @page.has_selector?(:css, 'div#collar_size[class*="closed"]', :visible => FALSE)
  end

  def collar_size_highlighted_in_red
    main_controls_section.has_selector?(:css, '*[class*="collar_size"][class*="has_errors"]')
  end

  def set_collar_size_by_index(index)
    collar_size_by_index(index).click
  end

  # Set the value in collar size selection box. This is done by clicking on a link within a table under a 'div' element (ie. div with the id = collar size).
  # This link is found by matching the link text to the specified 'value'.
  def set_collar_size_value(value)
    value_found = FALSE
    wait_until_element_present { @page.has_selector?(:css, %Q(div#collar_size[class*="open"] a)) }

    # Ignore out any other text apart from the actual size itself (eg. 'XXL Order now, stock due 03/08/2013')
    # But we have to add a space to the text we expect to find. ie. 'XXL' is really 'XXL '
    @size_value = %Q(#{value}\")
    link = %Q(//div[@id="collar_size"]//a[text()='#{@size_value}'])
    if @page.has_selector?(:xpath, link)
      @page.find(:xpath, link).click
      value_found = TRUE
    end
    return value_found
  end

  ####################################################################################
  # shortlist related methods - *** may relocate these to module common_methods.rb ***
  ####################################################################################
#  def minibar
#    @page.div(:class => "minibar")
#  end

#  def minibar_header
#    minibar.div(:class => "minibar_header")
#  end

#  def qty_in_shortlist
#    minibar_header.span(:id => "shotlistQty")
#  end

#  def minibar_products
#    @minibar.div(:class => "minibar_prods")
#  end

#  def view_all_items_text_link
#    minibar_products.link(:href => /ShortList\.aspx/)
#  end

#  def view_all_items_button
#    @minibar_header.link(:href => /ShortList\.aspx/)
#  end

#  def view_all_items_button_image
#    view_all_items_button.img(:src => /bt_view_my_shortlist/)
#  end

  ####################################################################################
  # customisation options related methods - eg. single/double cuff
  ####################################################################################

  def select_single_cuff
    @page.choose('sngl_cuff', :visible => FALSE)
  end

  def select_double_cuff
    @page.choose("dbl_cuff", :visible => FALSE)
  end

  def add_pocket_section
    @page.find(:div_id, "uniform-add_pocket")
  end

  def select_add_pocket
    @page.check('add_pocket', :visible => FALSE)
  end

  def add_pocket_is_checked
    add_pocket_section.has_selector?(:span_class, "checked") ? TRUE : FALSE
  end

  ####################################################################################
  # monogram related methods
  ####################################################################################

  def add_monogram_section
    @page.find(:div_id, "ctl00_contentBody_ctl02_addMngm")
  end

  def select_add_monogram
    @page.check('add_mngm', :visible => FALSE)
  end

  def monogram_description
    add_monogram_section.find(:div_id, "monogram_desc")
  end

  # span element that contains the checkbox and its value (ie. "checked" or "")
  def add_monogram_is_checked
    add_monogram_section.has_selector?(:span_class, "checked") ? TRUE : FALSE
  end

  #-----------------------------------------------------------------------------------
  ####################################################################################
  # define methods to call the page objects defined on the formal shirts page
  ####################################################################################
  #-----------------------------------------------------------------------------------

  # Open the match tie and cufflinks lightbox. Wait up to 10secs for it to open, return FALSE if it
  # didn't open
  def open_mtc_lightbox
    lightbox_opened = FALSE
    time_secs = 0

    mtc_link.click
    while time_secs < 10
      if @page.has_selector?(:div_id, 'tie_cufflink_matcher')
        lightbox_opened = TRUE
        break
      end
      sleep 0.5
      time_secs+=0.5
    end
    return lightbox_opened
  end

  #-----------------------------------------------------------------------------------
  ####################################################################################
  # define (page object) elements in "add monogram" lightbox
  ####################################################################################
  #-----------------------------------------------------------------------------------
  def monogram_lightbox
    @page.find('fieldset#monogram')
  end

  # add monogram button  (located at the bottom of the lightbox)
  def confirm_add_monogram
    monogram_lightbox.find('img#ctl00_contentBody_ctl02_ctl00_addMono', :visible => FALSE).click
  end

  # initials text box
  def fill_in_initials_text_box(text)
    #initials_text_box was monogram_lightbox.text_field(:id => "ctl00_contentBody_ctl02_ctl00_mg_initials")
    monogram_lightbox.fill_in('ctl00_contentBody_ctl02_ctl00_mg_initials', :with => text)
  end

  ##########################################################################
  # define methods for 'fonts' radio buttons
  ##########################################################################
  def select_brush_script_font
    monogram_lightbox.choose("mg_font_brush_script", :visible => FALSE)
  end

  def select_circle_font
    monogram_lightbox.choose("mg_font_circle", :visible => FALSE)
  end

  def select_clarendon_font
    monogram_lightbox.choose("mg_font_clarendon", :visible => FALSE)
  end

  def select_diamond_font
    monogram_lightbox.choose("mg_font_diamond", :visible => FALSE)
  end

  def select_old_english_font
    monogram_lightbox.choose("mg_font_olde_english", :visible => FALSE)
  end

  def select_roman_block_font
    monogram_lightbox.choose("mg_font_roman_block", :visible => FALSE)
  end

  def select_sports_script_font
    monogram_lightbox.choose("mg_font_sports_script", :visible => FALSE)
  end

  def select_upright_script_font
    monogram_lightbox.choose("mg_font_upright_script", :visible => FALSE)
  end

  ##########################################################################
  # define methods for 'colour' radio buttons
  ##########################################################################
  def select_colour_black
    monogram_lightbox.choose("mg_colour_black", :visible => FALSE)
  end

  def select_colour_burgundy
    monogram_lightbox.choose("mg_colour_burgundy", :visible => FALSE)
  end

  def select_colour_purple
    monogram_lightbox.choose("mg_colour_purple", :visible => FALSE)
  end

  def select_colour_navy
    monogram_lightbox.choose("mg_colour_blue", :visible => FALSE)
  end

  def select_colour_royal_blue
    monogram_lightbox.choose("mg_colour_royalblue", :visible => FALSE)
  end

  def select_colour_light_blue
    monogram_lightbox.choose("mg_colour_lightblue", :visible => FALSE)
  end

  def select_colour_racing_green
    monogram_lightbox.choose("mg_colour_racing_green", :visible => FALSE)
  end

  def select_colour_red
    monogram_lightbox.choose("mg_colour_red", :visible => FALSE)
  end

  def select_colour_pink
    monogram_lightbox.choose("mg_colour_pink", :visible => FALSE)
  end

  def select_colour_grey
    monogram_lightbox.choose("mg_colour_grey", :visible => FALSE)
  end

  def select_colour_yellow
    monogram_lightbox.choose("mg_colour_yellow", :visible => FALSE)
  end

  def select_colour_white
    monogram_lightbox.choose("mg_colour_white", :visible => FALSE)
  end

  ##########################################################################
  # define methods for 'position' radio buttons
  ##########################################################################
  def select_position_chest
    monogram_lightbox.choose("pos_chest", :visible => FALSE)
  end

  def select_position_cuff_centre
    monogram_lightbox.choose("pos_cuff_centre", :visible => FALSE)
  end

  def select_position_cuff_above_watch
    monogram_lightbox.choose("pos_cuff_watch", :visible => FALSE)
  end

  def select_position_cuff_below_link
    monogram_lightbox.choose("pos_cuff_link", :visible => FALSE)
  end

  #-----------------------------------------------------------------------------------
  ####################################################################################
  # define (page object) elements and simple methods for "what's my size" lightbox
  ####################################################################################
  #-----------------------------------------------------------------------------------

  # the "what's my size" link
  def whats_my_size_link
    @page.link("ctl00_contentBody_ctl02_sizeGuide")
  end

  # the "what's my size" lightbox (that contains measurements in inches or centimeters)
  def whats_my_size_lightbox
    @page.div(:id => "shirts_size_guide")
  end

  # the inner sections of the "what's my size" lightbox containing the measurement tables.
  # There should be 1 table for units in 'inches', and 1 table for units in 'cm'.
  # Note that only 1 table can be active (displayed) at one time.
  def wms_lightbox_tabbed_sections
    whats_my_size_lightbox.divs(:class => "tabbed section")
  end

  # the tabbed inner section of the "what's my size" lightbox with measurements displayed in 'units' (eg. inches)
  def wms_lightbox_tabbed_section(units)
    whats_my_size_lightbox.div(:class => "tabbed section", :id => "#{units}")
  end

  # the heading text describing the type of clothing eg. slim fit shirts
  def wms_header(units)
    wms_lightbox_tabbed_section(units).div(:class => "header").h3(:class => /.*/)
  end

  # the rows from the 'inches' measurement table that contain clothing item data and parameters (eg. sleeve length)
  def wms_data_table_rows(units)
    wms_lightbox_tabbed_section(units).table(:class => /.*/).tds(:class => /.*/)
  end

  # the column headings from the 'inches' measurement table (eg. collar size)
  def wms_data_table_columns(units)
    wms_lightbox_tabbed_section(units).table(:class => /.*/).ths(:class => /.*/)
  end

  # the link that is used to convert the measurement table data into 'cm'
  def convert_to_cm
    whats_my_size_lightbox.link(:href => /cm$/)
  end

  def errcheck_cm_link
    link = convert_to_cm
    if link.exists? != TRUE
      puts "\nERROR : The \'View in cm\' option cannot be found"
      link.exists?.should == TRUE
    end
  end

  # the link that is used to convert the measurement table data into 'inches'
  def convert_to_inches
    whats_my_size_lightbox.link(:href => /inch$/)
  end

  def errcheck_inch_link
    link = convert_to_inches
    if link.exists? != TRUE
      puts "\nERROR : The \'View in inches\' option cannot be found"
      link.exists?.should == TRUE
    end
  end

  #-----------------------------------------------------------------------------------
  ####################################################################################
  # define "what's my size" lightbox utility methods used by step definitions
  ####################################################################################
  #-----------------------------------------------------------------------------------

  # Find the current units displayed in the measurement table.
  def table_units_displayed
    # Wait until either of the 'div' elements has the style attribute set to "display: block"
    Watir::Wait.until { (wms_lightbox_tabbed_section(INCHES).style.downcase.include? ("block")) || (wms_lightbox_tabbed_section(CM).style.downcase.include? ("block")) }
    if wms_lightbox_tabbed_section(INCHES).style.downcase.include? ("block")
      # the 'div' element with class = "tabbed section" has the style attribute set to "display: block" when id = "inches". So units are in 'inches'
      return INCHES
    elsif wms_lightbox_tabbed_section(CM).style.downcase.include? ("block")
      # the 'div' element with class = "tabbed section" has the style attribute set to "display: block" when id = "cm". So units are in 'cm'
      return CM
    else
      return NONE
    end
  end

  # Attempt to find the specified text (eg. collar size) in the column headings of the measurement table.
  def find_table_column(column_text, units)
    return FALSE if (units != INCHES) && (units != CM)

    # search for 'column_text' in each measurement table column
    found_column_text = FALSE
    wms_data_table_columns(units).each do |table_column|
      if (table_column.text.downcase == column_text)
        found_column_text = TRUE
        break
      end
    end
    return found_column_text
  end

  # Attempt to find the specified text (eg. sleeve length) in the rows of the measurement table.
  def find_table_row(row_text, units)
    return FALSE if (units != INCHES) && (units != CM)

    # search for 'row_text' in each measurement table row
    found_row_text = FALSE
    wms_data_table_rows(units).each do |table_row|
      if (table_row.text.downcase == row_text)
        found_row_text = TRUE
        break
      end
    end
    return found_row_text
  end

  #-----------------------------------------------------------------------------------
  ####################################################################################
  # Define (page object) elements for "Match Tie and Cufflinks" lightbox
  ####################################################################################
  #-----------------------------------------------------------------------------------
  def mtc_heading_text
    mtc_lightbox.h2(:class => /.*/).text # should be == "Our recommended ties and cufflinks to match this shirt"
  end

  def mtc_shirt_main_photo(item_code)
    mtc_lightbox.img(:id=> "mainShirt", :src => /#{item_code}/)
  end

  def mtc_close_link
    mtc_lightbox.span(:class => "close").link(:href => /.*/)
  end

  def mtc_tie_in_main_photo(tie_item_code)
    mtc_lightbox.div(:class => "column current_selection").div(:class => "tie").img(:class => "main-image", :src => /#{tie_item_code}/)
  end

  def mtc_cufflinks_in_main_photo(cufflink_item_code)
    mtc_lightbox.div(:class => "column current_selection").div(:class => "cufflinks").img(:class => "main-image", :src => /#{cufflink_item_code}/)
  end

  ####################################################################################
  # Tie page object elements
  ####################################################################################
  def mtc_tie_thumb_photo(tie_item_code)
    mtc_lightbox.div(:class => "tie summary").link(:class => "detail-image").img(:src => /#{tie_item_code}/)
  end

  def mtc_prev_tie
    mtc_lightbox.div(:class => "rowNav").span(:class => /tie_nav/, :title=> "Select previous tie")
  end

  def mtc_next_tie
    mtc_lightbox.div(:class => "rowNav").span(:class => /tie_nav/, :title=> "Select next tie")
  end

  def mtc_prev_tie_thumb_photo(prev_tie_item_code)
    mtc_lightbox.div(:class => 'product_selector').div(:class => /right/).div(:class => "ties").li(:class => "show-prev").img(:class => "list-image", :src => /#{prev_tie_item_code}/)
  end

  def mtc_next_tie_thumb_photo(next_tie_item_code)
    mtc_lightbox.div(:class => 'product_selector').div(:class => /left/).div(:class => "ties").li(:class => "show-next").img(:class => "list-image", :src => /#{next_tie_item_code}/)
  end

  def mtc_add_tie_button
    mtc_lightbox.div(:class => "tie summary").button(:type => "image", :value => "Add to basket")
  end

  def mtc_add_tie_title_link(tie_item_code)
    mtc_lightbox.div(:class => "tie summary").div(:class => "details").link(:href => /#{tie_item_code}/)
  end

  def mtc_add_tie_description_text
    mtc_lightbox.div(:class => "tie summary").div(:class => "details").lis(:class => /.*/)
  end

  def mtc_tie_price_text
    mtc_lightbox.div(:class => "tie summary").div(:class => "purchasing").div(:class => "price").span(:class => "current")
  end

  def mtc_qty_ties_in_basket
    mtc_lightbox.div(:class => "tie summary").div(:class => "details").span(:class => "count").text.to_i
  end

  ####################################################################################
  # Cufflinks page object elements
  ####################################################################################
  def mtc_cufflinks_thumb_photo(cufflinks_item_code)
    mtc_lightbox.div(:class => "cufflinks summary").link(:class => "detail-image").img(:src => /#{cufflinks_item_code}/)
  end

  def mtc_prev_cufflinks
    mtc_lightbox.div(:class => "rowNav").span(:class => /cufflink_nav/, :title=> "Select previous cufflink")
  end

  def mtc_next_cufflinks
    mtc_lightbox.div(:class => "rowNav").span(:class => /cufflink_nav/, :title=> "Select next cufflink")
  end

  def mtc_prev_cufflinks_thumb_photo(prev_cufflinks_item_code)
    mtc_lightbox.div(:class => /right/).div(:class => "cufflinks").li(:class => "show-prev").img(:class => "list-image", :src => /#{prev_cufflinks_item_code}/)
  end

  def mtc_next_cufflinks_thumb_photo(next_cufflinks_item_code)
    mtc_lightbox.div(:class => /left/).div(:class => "cufflinks").li(:class => "show-next").img(:class => "list-image", :src => /#{next_cufflinks_item_code}/)
  end

  def mtc_add_cufflinks_button
    mtc_lightbox.div(:class => "cufflinks summary").button(:type => "image", :value => "Add to basket")
  end

  def mtc_add_cufflinks_title_link(cufflinks_item_code)
    mtc_lightbox.div(:class => "cufflinks summary").div(:class => "details").link(:href => /#{cufflinks_item_code}/)
  end

  def mtc_add_cufflinks_description_text
    mtc_lightbox.div(:class => "cufflinks summary").div(:class => "details").lis(:class => /.*/)
  end

  def mtc_cufflinks_price_text
    mtc_lightbox.div(:class => "cufflinks summary").div(:class => "purchasing").div(:class => "price").span(:class => "current")
  end

  def mtc_qty_cufflinks_in_basket
    mtc_lightbox.div(:class => "cufflinks summary").div(:class => "details").span(:class => "count").text.to_i
  end

  ####################################################################################
  # Match Tie and Cufflinks utility methods (ie. that call MTC page object elements)
  ####################################################################################
  def mtc_control_disabled(control)
    control.class_name.include? "disabled"
  end

  def mtc_change_tie(shift_type)
    @shift_disabled = FALSE
    if shift_type = NEXT
      if !mtc_control_disabled(mtc_next_tie)
        mtc_select_next_tie
      else
        @shift_disabled = TRUE
      end
    elsif shift_type = PREVIOUS
      if !mtc_control_disabled(mtc_prev_tie)
        mtc_select_prev_tie
      else
        @shift_disabled = TRUE
      end
    end
    return @shift_disabled
  end

  def mtc_change_cufflinks(shift_type)
    @shift_disabled = FALSE
    if shift_type = NEXT
      if !mtc_control_disabled(mtc_next_cufflinks)
        mtc_select_next_cufflinks
      else
        @shift_disabled = TRUE
      end
    elsif shift_type = PREVIOUS
      if !mtc_control_disabled(mtc_prev_cufflinks)
        mtc_select_prev_cufflinks
      else
        @shift_disabled = TRUE
      end
    end
    return @shift_disabled
  end

  def mtc_select_next_tie
    mtc_next_tie.when_present.fire_event("onclick")
  end

  def mtc_select_prev_tie
    mtc_prev_tie.when_present.fire_event("onclick")
  end

  def mtc_select_next_cufflinks
    mtc_next_cufflinks.when_present.fire_event("onclick")
  end

  def mtc_select_prev_cufflinks
    mtc_prev_cufflinks.when_present.fire_event("onclick")
  end

  def mtc_add_cufflinks_to_basket
    mtc_add_cufflinks_button.when_present.fire_event("onclick")
  end

  def mtc_add_tie_to_basket
    mtc_add_tie_button.when_present.fire_event("onclick")
  end

  def mtc_close
    mtc_close_link
  end
  #-----------------------------------------------------------------------------------
  ####################################################################################
  # fries popup/lightbox page object elements
  ####################################################################################
  #-----------------------------------------------------------------------------------

  # fries popup dialog
  def fries_popup
    @page.div(:id => "overlay_container", :class => "modal").div(:class => "fries_popup")
  end

  # fries popup 'close' link
  def close_fries_link
    fries_popup.span(:class => "close").link(:href => "#")
  end

  # fries link that loads the page displaying the shirts in the offer
  def fries_offer_link
    fries_popup.link(:class => "fries_cta", :href => /Lightboxlink/)
  end

  # main paragraph in the fries dialog
  def fries_main_paragraph
    fries_popup.p(:class => /.*/, :index => 0)
  end

  # lower paragraph in the fries dialog
  def fries_lower_paragraph
    fries_popup.p(:class => "last")
  end

  #-----------------------------------------------------------------------------------
  ##########################################################################
  # page object elements for website feedback popup
  ##########################################################################
  #-----------------------------------------------------------------------------------

  # root element of the popup
  def feedback_popup
    @page.div(:id => "layer_main_content")
  end

  # 'no thanks' button
  def no_thanks_button
    feedback_popup.div(:id => "layer_buttons").button(:id => "nothanks")
  end

  def yes_please_button
    feedback_popup.div(:id => "layer_buttons").button(:id => "yesplease")
  end
end