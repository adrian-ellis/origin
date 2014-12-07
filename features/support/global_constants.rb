########################################################################################################################################################################
################################################ All Constants needed by tests that use monograms ######################################################################
########################################################################################################################################################################
ALL_MG_FONTS = ['brush script', 'circle', 'clarendon', 'diamond', 'old english', 'roman block', 'sports script', 'upright script']
ALL_MG_COLOURS = ['black', 'burgundy', 'purple', 'navy', 'royal blue', 'light blue', 'racing green', 'red', 'pink', 'grey', 'yellow', 'white']
ALL_MG_POSITIONS = ['chest (left)', 'cuff centre', 'cuff above watch', 'cuff below link']
ALL_MG_POSITIONS_DE = {'chest (left)' => 'Brust (links)', 'cuff centre' => 'Manschette Mitte', 'cuff above watch' => 'Manschette uber Uhr', 'cuff below link' => 'Manschette unter Knopfloch'}

########################################################################################################################################################################
################################################ All Constants needed by MODULE CommonPageMethods ######################################################################
########################################################################################################################################################################
# Item identifiers for all men's shirts (ie. casual or formal) in both english and german languages. On both these shirts product pages these help to identify:-
#   1) the left navigation links
#   2) the shirt item thumbnail links
ALL_SHIRTS_IDENTIFIER_LANG_EN    = 'mens-shirts'
ALL_SHIRTS_IDENTIFIER_WQ_LANG_EN = "men's-shirts"
ALL_SHIRTS_IDENTIFIER_LANG_DE    = 'herren-hemden'

# Top (main menu) navigation control identifiers for casual and formal men's shirts for all countries
VIEW_ALL_SHIRTS_LANG_EN    = 'View all shirts'
VIEW_ALL_SHIRTS_LANG_DE    = 'Alle Hemden'

FORMAL_SHIRT_IDENTIFIER_GB = 'formal-shirts'
FORMAL_SHIRT_IDENTIFIER_US = 'dress-shirts'
FORMAL_SHIRT_IDENTIFIER_AU = 'business-shirts'
FORMAL_SHIRT_IDENTIFIER_DE = 'herren-businesshemden'

CASUAL_SHIRT_IDENTIFIER_GB = 'casual-shirts'
CASUAL_SHIRT_IDENTIFIER_US = 'sport-and-casual-shirts'
CASUAL_SHIRT_IDENTIFIER_AU = 'casual-shirts'
CASUAL_SHIRT_IDENTIFIER_DE  = 'herren-freizeithemden'

SEARCH_RESULTS_URL_IDENTIFIER    = "productlisting.aspx?q="
SEARCH_NO_RESULTS_URL_IDENTIFIER = "SearchNoResults.aspx?term="

NONE = "none"
ERROR = "error"

########################################################################################################################################################################
################################################ All Constants needed by MODULE CommonProductPage ######################################################################
########################################################################################################################################################################
# The indicies delimited by '|' in the (link) URL for each clothing item listed on the webpage.
INDEX_FOR_STOCK_CODE = 2
INDEX_FOR_PRICE_CODE = 5
INDEX_FOR_SIZE_CODE = 6
INDEX_FOR_OTHER_CATEGORIES = 7
INDEX_FOR_COLLAR_SIZE_CODE = 9
INDEX_FOR_SLEEVE_LENGTH = 10

################################################################################################
# The hashes below represent the category codes that are stored in the database tables
################################################################################################
FIT_LIST = { :classic => "381", :slim => "406", :extra_slim => "1861" }
COLLAR_SIZE_LIST = { :inch14_5 => "14.5", :inch15 => "15", :inch15_5 => "15.5", :inch16 => "16", :inch16_5 => "16.5", :inch17 => "17", :inch17_5 => "17.5", :inch18 => "18", :inch19 => "19", :inch20 => "20" }
SLEEVE_LENGTH_LIST = { :inch32 => "32", :inch33 => "33", :inch34 => "34", :inch35 => "35", :inch36 => "36", :inch37 => "37", :inch38 => "38" }
PRICE_LIST = { :gbp20_25 => "20 to 24.99", :gbp25_30 => "25 to 29.99", :gbp30_40 => "30 to 39.99", :gbp40_50 => "40 to 49.99", :gbp50_100 => "50 to 99.99" }
COLOUR_LIST = { :blue => "416", :green => "441", :multicolour => "456", :orange => "471", :pink => "476", :purple => "451", :reds => "481", :stone => "3606", :white => "491", :yellow => "496" }
RANGE_LIST = { :washed_oxford => "2186", :non_iron_casual => "3496", :jermyn_street_weekend => "4202", :slim_fit_oxford => "4572", :soft_twill => "3506", :summer_checks_and_stripes => "3761", :washed_favourite => "2176", :all_other_ranges => "3511" }
MATERIAL_LIST = { :pcnt100_cotton => "41", :non_iron_cotton => "1606", :linen_mix => "66" }
DESIGN_LIST = { :check => "146", :gingham_check => "3566", :plain => "221", :stripe => "236", :bengal_stripes => "unknown" }
COLLAR_TYPE_LIST = { :button_down => "4257", :classic => "4267" }
SLEEVE_TYPE_LIST = { :short_sleeve => "4392" }
CUFF_SLEEVE_LIST = { :short_sleeve => "4427" }
WEAVE_LIST = { :poplin => "427", :end_on_end => "unknown", :oxford_weave => "4537", :twill => "4227"}

# Country codes
GB = "GB"
DE = "DE"
AU = "AU"
US = "US"

FORMAL_SHIRTS = 'Formal Shirts'
CASUAL_SHIRTS = 'Casual Shirts'

# Formal Shirt Product Page URL's for each country
UK_FORMAL_PRODUCT_PAGE  = BASE_URL + "/mens-shirts/mens-formal-shirts?q=gbpdefault|||||||||||||||"
USA_FORMAL_PRODUCT_PAGE = BASE_URL + "/mens-shirts/mens-dress-shirts?q=usddefault|||||||||||||||"
AUS_FORMAL_PRODUCT_PAGE = BASE_URL + "/mens-shirts/mens-business-shirts?q=auddefault|||||||||||||||"
GER_FORMAL_PRODUCT_PAGE = BASE_URL + "/herren-hemden/herren-businesshemden?q=dmdefault|||||||||||||||"

# Casual Shirt Product Page URL's for each country
UK_CASUAL_SHIRTS_PRODUCT_PAGE  = BASE_URL + "/mens-shirts/mens-casual-shirts?q=gbpdefault|||||||||||||||"
USA_CASUAL_SHIRTS_PRODUCT_PAGE = BASE_URL + "/mens-shirts/mens-sport-and-casual-shirts?q=usddefault|||||||||||||||"
AUS_CASUAL_SHIRTS_PRODUCT_PAGE = BASE_URL + "/mens-shirts/mens-casual-shirts?q=auddefault|||||||||||||||"
GER_CASUAL_SHIRTS_PRODUCT_PAGE = BASE_URL + "/herren-hemden/herren-freizeithemden?q=dmdefault|||||||||||||||"

# Page result links
SHOW_ALL         = "Show all"
SHOW_15          = "Show 15 per page"
NEXT             = "Next"
SHOW_ALL_LANG_DE = "Alle anzeigen"
SHOW_15_LANG_DE  = "Zeige 15 pro Seite"
NEXT_LANG_DE     = "weiter"

NUMBER_OF_FIRST_ROW_ITEMS = 3

# Search Results Error Page 'SearchNoResults.aspx' name
SEARCH_RESULTS_ERROR = "SearchNoResults"


###############################################################################################################################################################################
################################################ 'Page Type' and "Currency Type" Constants needed by MODULE TeliumTags ########################################################
###############################################################################################################################################################################
PAGE_TYPE = { "Default" => 0, "Home" => 1, "AccountCredit" => 2, "AccountLogin" => 3, "AddressBook" => 4, "Basket" => 5, "Confirm" => 6, "Content" => 7, "Delivery" => 8,
              "GiftVoucherEmail" => 9, "GiftVoucherPaper" =>	10, "GiftVoucherPreview" => 11, "Login" => 12, "OrderConfirmed" => 13, "OrderHistory" => 14, "OutfitDetail" => 15,
              "OutfitListing" => 16, "Payment" => 17, "Preferences" => 18, "ProductCategory" => 19, "ProductDepartment" => 20, "ProductDetail" => 21, "ProductListing" => 22,
              "RequestCatalogue" => 23, "Search" => 24, "SearchNoResult" => 25, "ShortList" => 26 }


COUNTRY_CURRENCY = {"GB" => "GBP", "US" => "USD", "AU" => "AUD", "DE" => "EUR"}
PROPER_ITEM_NAME_COMPARISON = TRUE


