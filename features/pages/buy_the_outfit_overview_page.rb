BUY_THE_OUTFIT_OVERVIEW_PAGE = BASE_URL + "/Outfitlisting.aspx"
OUTFIT_PARTIAL_URL = /OutfitDetail.aspx\?oid=/
CLASSIC_FORMAL_OUTFIT_PARTIAL_URL = /OutfitDetail.aspx\?oid=8/
CLASSIC_FORMAL_OUTFIT_PARTIAL_URL_STRING = BASE_URL + "/OutfitDetail.aspx?oid=" + "8"
TOTAL_NUMBER_OF_OUTFITS = 9

# include common methods for page object classes (located in common_modules.rb)
include CommonPageMethods
include Waiting

class BuyOutfitOverviewPage

  #######################################################################
  # define page objects on the "basket" page
  #######################################################################
  def initialize(browser,country)
    @browser = browser
    @country = country
    @item_identifier_lang_en   = /buy_the_outfit/
  end

  # main carousel containing all the outfits on this page
  def main_carousel
    @browser.div(:id => "buy_the_look_carousel")
  end

  # links to each "Outfit" page
  def carousel_item_links
    main_carousel.links(:href => OUTFIT_PARTIAL_URL)
  end

  def carousel_item_classic_formal_link
    main_carousel.link(:href => CLASSIC_FORMAL_OUTFIT_PARTIAL_URL)
  end

  # these are the 'cufontext' elements that hold the title for each "Outfit"
  def cufontext_test
    carousel_item_links.span(:class => "title").elements(:tag_name => "cufontext")
  end
end
