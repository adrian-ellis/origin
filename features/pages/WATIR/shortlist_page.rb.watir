class ShortlistPage
  # include common methods for page object classes (located in common_modules.rb)
  include CommonPageMethods
  include Waiting
  include Lightboxes
  include TeliumTags

  #-----------------------------------------------------------------------------------
  ####################################################################################
  # define page objects on the Shortlist page
  ####################################################################################
  #-----------------------------------------------------------------------------------
  attr_accessor :all_maybe_item_ids, :all_maybe_item_codes, :all_yes_item_ids, :all_yes_item_codes, :all_no_item_ids, :all_no_item_codes, :target_item_id, :target_item_code

  def initialize(browser,country)
    @browser = browser
    @country = country
    @all_maybe_item_ids = []
    @all_maybe_item_codes = []
    @all_yes_item_ids = []
    @all_yes_item_codes = []
    @all_no_item_ids = []
    @all_no_item_codes = []
    @target_item_id = ""
    @target_item_code = ""
  end

  def header
    @browser.div(:class => "header simple_header")
  end

  ####################################################################################
  # define 'Maybe' column page objects
  ####################################################################################
  def maybe_column
    @browser.div(:class => /shortlist_area shortlist_maybe/)
  end

  # These elements are hidden buttons whose 'value' attribute contains the 'item id'.
  # An 'item id' is a unique identifier for each item in the 'Maybe' column
  def all_maybe_item_id_marker_fields
    maybe_column.buttons(:name => "itemId[]")
  end

  def first_maybe_item_id_root_div
    maybe_column.div(:class => "inner", :id => /\d+/)
  end

  def maybe_item_id_root_div(shortlist_item_id)
    maybe_column.div(:class => "inner", :id => /#{shortlist_item_id}/)
  end

  def maybe_item_id_root_divs
    maybe_column.divs(:class => "inner", :id => /\d+/)
  end

  def maybe_item_heading_text(shortlist_item_id, item_code)
    maybe_item_id_root_div(shortlist_item_id).element(tag_name => "h2", :class => "prod_name").link(:href => /#{item_code}/)
  end

  # link to a specific item thumbnail photo contained in the 'Maybe' column
  def maybe_item_thumb_link(shortlist_item_id, item_code)
    maybe_item_id_root_div(shortlist_item_id).link(:class => "img", :href => /#{item_code}/)
  end

  # links to all the item thumbnail photos contained in the 'Maybe' column
  def maybe_item_thumb_links
    maybe_column.links(:class => "img", :href => /.*/) # ---------------------------------- EVERYTHING USING THIS NEEDS REPLACING!!!!!!!!
  end

  def remove_from_maybe_column(shortlist_item_id)
    button_id = "btn_remove_" + shortlist_item_id
    maybe_item_id_root_div(shortlist_item_id).link(:id => button_id)
  end

  ####################################################################################
  # define 'yes' column page objects
  ####################################################################################
  def yes_column
    @browser.div(:class => "shortlist_area shortlist_yes section")
  end

  ####################################################################################
  # define 'no' column page objects
  ####################################################################################
  def no_column
    @browser.div(:class => "shortlist_area shortlist_no section")
  end

  # These elements are hidden buttons whose 'value' attribute contains the 'item id'.
  # An 'item id' is a unique identifier for each item in the 'Maybe' column
  def all_no_item_id_marker_fields
    no_column.buttons(:name => "itemId[]")
  end

  def first_no_item_id_root_div
    no_column.div(:class => "inner", :id => /\d+/)
  end

  def no_item_id_root_div(shortlist_item_id)
    no_column.div(:class => "inner", :id => /#{shortlist_item_id}/)
  end

  def no_item_id_root_divs
    no_column.divs(:class => "inner", :id => /\d+/)
  end

  def no_item_heading_text(shortlist_item_id, item_code)
    no_item_id_root_div(shortlist_item_id).element(tag_name => "h2", :class => "prod_name").link(:href => /#{item_code}/)
  end

  # link to a specific item thumbnail photo contained in the 'Maybe' column
  def no_item_thumb_link(shortlist_item_id, item_code)
    no_item_id_root_div(shortlist_item_id).link(:class => "img", :href => /#{item_code}/)
  end

  # links to all the item thumbnail photos contained in the 'Maybe' column
  def no_item_thumb_links
    no_column.links(:class => "img", :href => /.*/) # ---------------------------------- EVERYTHING USING THIS NEEDS REPLACING!!!!!!!!
  end

  def remove_from_no_column
    no_column.link(:id=> "ctl00_contentBody_btnRemoveAllItems")
  end

  #-----------------------------------------------------------------------------------
  ####################################################################################
  # define utility methods
  ####################################################################################
  #-----------------------------------------------------------------------------------
  def all_maybe_items
    @all_maybe = {}
    wait_until_element_present(maybe_column)
    maybe_item_id_root_divs.each do |item_div|
      # get shortlist item id (that is used as a key to locate each item in the My Shortlist page)
      id_attribute = item_div.attribute_value("id")
      shortlist_item_id = id_attribute.strip

      # get item code of shortlist item
      item_codes_from_url = item_div.link(:class => "img", :href => /.*/).href.split "|"
      item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

      # add to hash that contains item id (as key) and item code (as value)
      @all_maybe.merge!(shortlist_item_id => item_product_code)
    end
    return @all_maybe # return the hash
  end

  def all_no_items
    @all_no = {}
    wait_until_element_present(no_column)
    no_item_id_root_divs.each do |item_div|
      # get shortlist item id (that is used as a key to locate each item in the My Shortlist page)
      id_attribute = item_div.attribute_value("id")
      shortlist_item_id = id_attribute.strip

      # get item code of shortlist item
      item_codes_from_url = item_div.link(:class => "img", :href => /.*/).href.split "|"
      item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

      # add to hash that contains item id (as key) and item code (as value)
      @all_no.merge!(shortlist_item_id => item_product_code)
    end
    return @all_no # return the hash
  end

  def all_yes_items
    @all_yes = {}
    wait_until_element_present(yes_column)
    yes_item_id_root_divs.each do |item_div|
      # get shortlist item id (that is used as a key to locate each item in the My Shortlist page)
      id_attribute = item_div.attribute_value("id")
      shortlist_item_id = id_attribute.strip

      # get item code of shortlist item
      item_codes_from_url = item_div.link(:class => "img", :href => /.*/).href.split "|"
      item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

      # add to hash that contains item id (as key) and item code (as value)
      @all_yes.merge!(shortlist_item_id => item_product_code)
    end
    return @all_yes # return the hash
  end

  ###### LEGACY METHOD - use hashes instead now ################
  def get_all_items(column,target_item_code)
    @target_item_id = ""
    @target_item_code = ""
    all_shortlist_item_ids = []
    all_shortlist_item_codes = []

    if column == "maybe"
      column_present = maybe_column
      first_item_id_root_div = first_maybe_item_id_root_div
      item_id_root_divs = maybe_item_id_root_divs
    elsif column == "no"
      column_present = no_column
      first_item_id_root_div = first_no_item_id_root_div
      item_id_root_divs = no_item_id_root_divs
    elsif column == "yes"
      column_present = yes_column
      first_item_id_root_div = first_yes_item_id_root_div
      item_id_root_divs = yes_item_id_root_divs
    end

    wait_until_element_present(column_present)
    if first_item_id_root_div.exists? == TRUE
      item_id_root_divs.each do |item_div|
        # get shortlist item id (that is used as a key to locate each item in the My Shortlist page)
        id_attribute = item_div.attribute_value("id")
        shortlist_item_id = id_attribute.strip

        # get item code of shortlist item
        item_codes_from_url = item_div.link(:class => "img", :href => /.*/).href.split "|"
        item_product_code = item_codes_from_url[INDEX_FOR_STOCK_CODE]

        # store shortlist item id's in an array (that we can use later to retrieve all information relating to each item)
        all_shortlist_item_ids.push(shortlist_item_id)
        all_shortlist_item_codes.push(item_product_code)

        # locate the target item for which the quantity is updated, by using its item code
        if (item_product_code == target_item_code)
          @target_item_code = item_product_code
          @target_item_id = shortlist_item_id
        end
      end
    end

    if column == "maybe"
      @all_maybe_item_ids = all_shortlist_item_ids
      @all_maybe_item_codes = all_shortlist_item_codes
    elsif column == "no"
      @all_no_item_ids = all_shortlist_item_ids
      @all_no_item_codes = all_shortlist_item_codes
    elsif column == "yes"
      @all_yes_item_ids = all_shortlist_item_ids
      @all_yes_item_codes = all_shortlist_item_codes
    end
  end


  # Wait until the element in question has loaded. This is very useful in the situation where
  # page elements are loading too slowly (and causing the test to fail as a consequence).
  def wait_until_element_present(element)
    element.when_present.exists?
  end
end

