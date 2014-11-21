BUY_THE_OUTFIT_OVERVIEW_PAGE = BASE_URL + "/Outfitlisting.aspx"
OUTFIT_PARTIAL_URL = /OutfitDetail.aspx\?oid=/
CLASSIC_FORMAL_OUTFIT_PARTIAL_URL = /OutfitDetail.aspx\?oid=8/
CLASSIC_FORMAL_OUTFIT_URL_STRING = BASE_URL + "/OutfitDetail.aspx?oid=" + "8"
PROMPT_TO_SELECT = "please select"

# include common methods for page object classes (located in common_modules.rb)
include CommonPageMethods
include Waiting

class BuyOutfitDetailPage

  #######################################################################
  # define page objects on the "basket" page
  #######################################################################
  def initialize(browser,country)
    @browser = browser
    @country = country
    @item_identifier_lang_en   = /buy_the_outfit/
  end

  def page_header
    @browser.div(:id => "masthead")
  end

  def basket_link
    @browser.div(:id => "basket_nav").span(:class => "bskt_items").link(:href => BASKET_LINK_URL)
  end

  # element that gives the quantity of items in the basket
  def basket_items_qty
    @browser.div(:id => "basket_nav").span(:class => "bskt_items").link(:href => BASKET_LINK_URL).span(:id => "miniBKQty")
  end

  def ajax_form
    @browser.form(:class => /buy-outfit/)
  end

  def jacket_chest_size_selection_box
    @browser.link(:href => /jckt_chest_100/, :class => "tooltip_link")
  end
  
  def jacket_sleeve_length_selection_box
    @browser.link(:href => /slv_lngth_100/, :class => "tooltip_link")
  end

  # select value in jacket chest size selection box by index
  def select_jacket_chest_size_by_index(index)
    @index = index
    @browser.div(:id => "jckt_chest_100").link(:href => /.*/, :index => @index)
  end

  # select value in sleeve length size selection box by index
  def select_sleeve_length_by_index(index)
    @index = index
    @browser.div(:id => "slv_lngth_100").link(:href => /.*/, :index => @index)
  end



  def add_jacket_to_basket
    @browser.button(:id => "ctl00_contentBody_ctl00_ctl03_submit")
  end

  def add_trousers_to_basket
    @browser.button(:id => "ctl00_contentBody_ctl01_ctl03_submit")
  end

  def add_waistcoat_to_basket
    @browser.button(:id => "ctl00_contentBody_ctl02_ctl03_submit")
  end

  def add_shirt_to_basket
    @browser.button(:id => "ctl00_contentBody_ctl03_ctl03_submit")
  end
  
  def add_tie_to_basket
    @browser.button(:id => "ctl00_contentBody_ctl04_ctl03_submit")
  end

  def add_shoes_to_basket
    @browser.button(:id => "ctl00_contentBody_ctl05_ctl03_submit")
  end

  def visit_outfit_page
    @browser.goto CLASSIC_FORMAL_OUTFIT_URL_STRING
  end
end