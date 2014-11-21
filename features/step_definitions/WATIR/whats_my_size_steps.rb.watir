# measurement units
INCHES = "inches"
INCH = "inch"
CM = "cm"

# types of measurement in the column and rows of the measurement table
COLLAR_SIZE = "collar size"
SLEEVE_LENGTH = "sleeve length"

# constants defined for this proof of concept
FORMAL_SHIRTS_ITEM_DETAIL_PAGE_SS050RYL = "http://www.ctshirts.co.uk/men's-shirts/men's-formal-shirts/Royal-gingham-short-sleeve-classic-shirt?q=gbpdefault||SS050RYL|||||||16,||||||"
FORMAL_SHIRTS_ITEM_DETAIL_PAGE_FP027LLC = "http://www.ctshirts.co.uk/men's-shirts/men's-formal-shirts/Easy--to--iron-lilac-poplin-slim-fit-shirt?q=gbpdefault||FP027LLC|||||||16,||||||"
SLIM_FIT_SHIRTS = "slim fit shirts"
CLASSIC_SHORT_SLEEVE_SHIRTS = "classic short sleeve shirts"
@units = NONE

Given /^I am on the product item detail page for the product item "(.*?)" which belongs to "(.*?)"$/ do |product_item_code, product_type|
  product_item = [FORMAL_SHIRTS_ITEM_DETAIL_PAGE_FP027LLC, FORMAL_SHIRTS_ITEM_DETAIL_PAGE_SS050RYL]
  @page = FormalShirtsItemDetailPage.new(@browser)

  # open browser and load item detail page (NOTE : this is just an initial proof of concept, it will be replaced by code that will make it possible tor run directly from the scenario input thereby allowing us to choose any casual or formal shirt type)
  @page.load_item_detail_page(FORMAL_SHIRTS_ITEM_DETAIL_PAGE_FP027LLC)
  sleep 2
end

When /^I select Whats My Size on the product item detail page for "(.*?)"$/ do |product_item_code|
  @page.whats_my_size_link.exists?.should == TRUE
  @page.whats_my_size_link.click
end


Then /^the "(.*?)" Whats My Size lightbox is displayed$/ do |product_type|
  # verify that the lightbox is displayed
  if @page.whats_my_size_lightbox.exists? != TRUE
    puts "\nERROR : \'whats my size\' lightbox is missing"
    @page.whats_my_size_lightbox.exists?.should == TRUE
  end
end


And /^the "(.*?)" Whats My Size lightbox contains the measurements suitable for "(.*?)"$/ do |lightbox_type, product_type|
  #################################################################################################
  # verify the elements in the lightbox have values consistent with the type of product displayed
  #################################################################################################
  
  # verify that a (div) block that contains the measurement table is present
  if @page.wms_lightbox_tabbed_sections == nil
    puts "\nERROR in \'whats my size\' lightbox : missing measurement table"
    @page.wms_lightbox_tabbed_sections.should_not == nil
  end

  # verify that the value of the 'id' attribute of the (div) block is either 'inches' or 'cm'
  if (@page.wms_lightbox_tabbed_section(INCHES).exists? != TRUE) && (@page.wms_lightbox_tabbed_section(CM).exists? != TRUE)
    puts "\nERROR in \'whats my size\' lightbox : missing units \'inches\' and \'cm\' in measurement table"
    @page.wms_lightbox_tabbed_section(INCHES).exists?.should == TRUE
  end

  # Find the units for the currently displayed measurement table (eg. inches)
  @units = @page.table_units_displayed
  if @units == NONE
     puts "\nERROR in \'whats my size\' lightbox : unknown units in measurement table"
     @units.should_not == NONE
  end
  
  # verify title of the measurement table (eg. slim fit shirts) is present
  if @page.wms_header(@units).exists? != TRUE
     puts "\nERROR in \'whats my size\' lightbox : missing product title"
     @page.wms_header(@units).exists?.should == TRUE
  end

  # Verify that the title of the table matches the 'product type' given for this scenario (eg. slim fit shirts)
  # (NOTE : for SLIM_FIT_SHIRTS hard coded value: this is just an initial proof of concept, it will be replaced by product_type)
  if @page.wms_header(@units).text.downcase != SLIM_FIT_SHIRTS
    puts "\nERROR in \'whats my size\' lightbox : incorrect product title"
    @page.wms_header(@units).text.downcase.should == SLIM_FIT_SHIRTS
  end

  # verify columns in the measurement table are present
  if @page.wms_data_table_columns(@units) == nil
    puts "\nERROR in \'whats my size\' lightbox : missing columns in measurement table"
    @page.wms_data_table_columns(@units).should_not == nil
  end

  # verify rows in measurement table are present
   if @page.wms_data_table_rows(@units) == nil
    puts "\nERROR in \'whats my size\' lightbox : missing rows in measurement table"
    @page.wms_data_table_rows(@units).should_not == nil
   end

  # Search through the column names in the measurement table to verify that the specific text (eg. collar size) is present
  result = @page.find_table_column(COLLAR_SIZE, @units)
  if result != TRUE
    puts "\nERROR in \'whats my size\' lightbox : missing column name #{COLLAR_SIZE} in measurement table"
    result.should == TRUE	
  end  

  # Search through the rows in the measurement table to verify that the specific text (eg. sleeve length) is present
  result = @page.find_table_row(SLEEVE_LENGTH, @units)
  if result != TRUE
    puts "\nERROR in \'whats my size\' lightbox : missing row name #{SLEEVE_LENGTH} in measurement table"
    result.should == TRUE	
  end  
end


And /^the "(.*?)" Whats My Size lightbox displayed contains measurements in "(.*?)"$/ do |product_type, initial_units|
  #######################################################################################
  # Open the lightbox. This a precondition for any test that assumes the lightbox to be open.
  #######################################################################################
  @page.whats_my_size_link.exists?.should == TRUE
  @page.whats_my_size_link.click

  #################################################################################################
  # verify the elements in the lightbox have values consistent with the type of product displayed
  #################################################################################################
  
  # verify that a (div) block that contains the measurement table is present
  if @page.wms_lightbox_tabbed_sections == nil
    puts "\nERROR in \'whats my size\' lightbox : missing measurement table"
    @page.wms_lightbox_tabbed_sections.should_not == nil
  end

  # verify that the value of the 'id' attribute of the (div) block is either 'inches' or 'cm'
  if (@page.wms_lightbox_tabbed_section(INCHES).exists? != TRUE) && (@page.wms_lightbox_tabbed_section(CM).exists? != TRUE)
    puts "\nERROR in \'whats my size\' lightbox : missing units \'inches\' and \'cm\' in measurement table"
    @page.wms_lightbox_tabbed_section(INCHES).exists?.should == TRUE
  end

  # Find the units for the currently displayed measurement table (eg. inches)
  @units = @page.table_units_displayed
  if @units == NONE
     puts "\nERROR in \'whats my size\' lightbox : unknown units in measurement table"
     @units.should_not == NONE
  end
  
  # verify title of the measurement table (eg. slim fit shirts) is present
  if @page.wms_header(@units).exists? != TRUE
     puts "\nERROR in \'whats my size\' lightbox : missing product title"
     @page.wms_header(@units).exists?.should == TRUE
  end

  # Verify that the title of the table matches the 'product type' given for this scenario (eg. slim fit shirts)
  # (NOTE : for SLIM_FIT_SHIRTS hard coded value: this is just an initial proof of concept, it will be replaced by product_type)
  if @page.wms_header(@units).text.downcase != SLIM_FIT_SHIRTS
    puts "\nERROR in \'whats my size\' lightbox : incorrect product title"
    @page.wms_header(@units).text.downcase.should == SLIM_FIT_SHIRTS
  end

  # verify columns in the measurement table are present
  if @page.wms_data_table_columns(@units) == nil
    puts "\nERROR in \'whats my size\' lightbox : missing columns in measurement table"
    @page.wms_data_table_columns(@units).should_not == nil
  end

  # verify rows in measurement table are present
   if @page.wms_data_table_rows(@units) == nil
    puts "\nERROR in \'whats my size\' lightbox : missing rows in measurement table"
    @page.wms_data_table_rows(@units).should_not == nil
   end

  # Search through the column names in the measurement table to verify that the specific text (eg. collar size) is present
  result = @page.find_table_column(COLLAR_SIZE, @units)
  if result != TRUE
    puts "\nERROR in \'whats my size\' lightbox : missing column name #{COLLAR_SIZE} in measurement table"
    result.should == TRUE	
  end  

  # Search through the rows in the measurement table to verify that the specific text (eg. sleeve length) is present
  result = @page.find_table_row(SLEEVE_LENGTH, @units)
  if result != TRUE
    puts "\nERROR in \'whats my size\' lightbox : missing row name #{SLEEVE_LENGTH} in measurement table"
    result.should == TRUE	
  end  
end


When /^I select View In "(.*?)"$/ do |target_units|
  if target_units.downcase == CM
    # Find the units for the currently displayed measurement table (eg. inches)
    @units = @page.table_units_displayed

    # If current units are 'cm', must convert to 'inches' first	
    @page.convert_to_inches.click if @units == CM

    # convert to 'cm'
    @page.convert_to_cm.click

  elsif target_units.downcase == INCHES
    # Find the units for the currently displayed measurement table (eg. inches)
    @units = @page.table_units_displayed

    # If current units are 'inches', must convert to 'cm' first	
    @page.convert_to_cm.click if @units == INCHES

    # convert to 'inches'
    @page.convert_to_inches.click
  else	
    puts "\nWARNING : The \'View in #{target_units}\' option is not available. Only valid options are \'inches\' or \'cm\'"
  end
end


Then /^the measurements in the Whats My Size lightbox are converted to "(.*?)"$/ do |target_units|
  ######################################################################
  # Verify that the measurement table is being viewed in units of 'cm'.
  ######################################################################
  if target_units.downcase == CM
    # Find the units for the currently displayed measurement table
    @units = @page.table_units_displayed
    if @units != CM
      puts "\nERROR : The measurement table failed to be displayed in units of \'cm\' "
      @units.should == CM
    end
	
	# check how many table rows are found with units of 'cm'
    found_units_in_cm = 0
    @page.wms_data_table_rows(@units).each do |table_row|
      found_units_in_cm = found_units_in_cm + 1 if (table_row.text.downcase == CM)
    end
    puts "\nINFO : #{found_units_in_cm} table rows found with units in \'cm\'"

  ######################################################################
  # Verify that the measurement table is being viewed in units of 'cm'.
  ######################################################################
  elsif target_units.downcase == INCHES

    # Find the units for the currently displayed measurement table
    @units = @page.table_units_displayed
    if @units != INCHES
      puts "\nERROR : The measurement table failed to be displayed in units of \'inches\' "
      @units.should == INCHES
    end

	# check how many table rows are found with units of 'inch'
    found_units_in_inches = 0
    @page.wms_data_table_rows(@units).each do |table_row|
      found_units_in_inches = found_units_in_inches + 1 if (table_row.text.downcase == INCH)
    end
    puts "\nINFO : #{found_units_in_inches} table rows found with units in \'inches\'"
  else	
    puts "\nWARNING : The \'View in #{target_units}\' option is not available. I already told you. Only valid options are \'inches\' or \'cm\'"
  end
end

