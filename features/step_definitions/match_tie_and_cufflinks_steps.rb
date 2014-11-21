# define constants used in following step definitions
TIE = "tie"
CUFFLINKS = "cufflinks"
#NEXT = "next"
PREVIOUS = "previous"

########################################################################################################################
##################     Scenario: Verify that the "Match Tie and Cufflinks" lightbox appears        #####################
########################################################################################################################
Given /^I am on the product item detail page for formal shirt "(.*?)"$/ do |product_item_code|
  # set all tie and cufflink item codes to the generic first letter of all of those types of products
  @product_item_code = product_item_code
  @tie_item_code = @prev_tie_item_code = @next_tie_item_code = "T"
  @cufflinks_item_code = @prev_cufflinks_item_code = @next_cufflinks_item_code = "L"
  @mtc_tie_thumb_photo_src = []
  @mtc_cufflinks_thumb_photo_src = []
  @tie_shift = 0
  @cufflinks_shift = 0
  @tie_shift_disabled = FALSE
  @cufflinks_shift_disabled = FALSE

  # Load the formal shirt detail page for the item code provided in the scenario data table. Provide collar size.
  #COLLAR_SIZE = "15"
#  @frmlProdPage = FormalShirtsPage.new(@browser,GB)

  # Use the product search facility at the top of the page to load the detail page for the specified formal shirt
  @detailPage = @page.search_for_formal_shirt(product_item_code)

#  @page = @frmlProdPage.load_formal_shirt_detail_page(product_item_code)
  @detailPage.wait_until_element_present(@detailPage.main_controls_section)
end

When /^I select Match Tie and Cufflinks$/ do
  @detailPage.mtc_link.exists?.should == TRUE
  @lightbox_opened = @detailPage.open_mtc_lightbox
end

Then /^the Match Tie and Cufflinks lightbox appears$/ do
  if !@lightbox_opened
    puts "\nERROR: Match Tie and Cufflinks lightbox failed to open"
    @lightbox_opened.should == TRUE
  end
end

And /^the Match Tie and Cufflinks lightbox contains a preview photo of the currently displayed Shirt, Tie and Cufflinks for "(.*?)"$/ do |product_item_code|
  # wait for main shirt photo to load, then verfiy that the other objects on page exist.
  @detailPage.wait_until_element_present(@detailPage.mtc_shirt_main_photo(product_item_code))
  @detailPage.mtc_shirt_main_photo(product_item_code).exists?.should == TRUE
  @detailPage.mtc_tie_in_main_photo(@tie_item_code).exists?.should == TRUE
  @detailPage.mtc_cufflinks_in_main_photo(@cufflinks_item_code).exists?.should == TRUE
end

And /^the Match Tie and Cufflinks lightbox contains previous and next navigation buttons for both Ties and Cufflinks$/ do
  @detailPage.mtc_prev_tie.exists?.should == TRUE
  @detailPage.mtc_next_tie.exists?.should == TRUE
  @detailPage.mtc_prev_cufflinks.exists?.should == TRUE
  @detailPage.mtc_next_cufflinks.exists?.should == TRUE
end

And /^the Match Tie and Cufflinks lightbox contains a Title, Description, Thumbnail Photo and Add To Basket link for the currently displayed Tie and Cufflinks$/ do
  @detailPage.mtc_prev_tie.exists?.should == TRUE
  @detailPage.mtc_next_tie.exists?.should == TRUE
  @detailPage.mtc_tie_thumb_photo(@tie_item_code).exists?.should == TRUE
  @detailPage.mtc_prev_tie_thumb_photo(@prev_tie_item_code).exists?.should == TRUE
  @detailPage.mtc_next_tie_thumb_photo(@next_tie_item_code).exists?.should == TRUE
  @detailPage.mtc_add_tie_title_link(@tie_item_code).exists?.should == TRUE
  @detailPage.mtc_add_tie_description_text != nil
  @detailPage.mtc_tie_price_text.exists?.should == TRUE
  @detailPage.mtc_add_tie_button.exists?.should == TRUE

  @detailPage.mtc_prev_cufflinks.exists?.should == TRUE
  @detailPage.mtc_next_cufflinks.exists?.should == TRUE
  @detailPage.mtc_cufflinks_thumb_photo(@cufflinks_item_code).exists?.should == TRUE
  @detailPage.mtc_prev_cufflinks_thumb_photo(@prev_cufflinks_item_code).exists?.should == TRUE
  @detailPage.mtc_next_cufflinks_thumb_photo(@next_cufflinks_item_code).exists?.should == TRUE
  @detailPage.mtc_add_cufflinks_title_link(@cufflinks_item_code).exists?.should == TRUE
  @detailPage.mtc_add_cufflinks_description_text != nil
  @detailPage.mtc_cufflinks_price_text.exists?.should == TRUE
  @detailPage.mtc_add_cufflinks_button.exists?.should == TRUE
end

########################################################################################################################
#########     Scenario: Match a set of Tie and Cufflinks to a formal shirt then add them to the Basket        ##########
########################################################################################################################
# No control shifts are required, if the values in the scenario data table are invalid or missing.
# Using 'tie' and 'cufflinks' that are displayed when the Match Tie and Cufflinks lightbox opens.
PRODUCT   = "product"
DIRECTION = "direction"
def display_warning_msg(type)
  if type == PRODUCT
    puts "\nINFO: You must specify either \'ties\' or \'cufflinks\' in the \'product\' column of the scenario data table."
  elsif type == DIRECTION
    puts "\nINFO: You must specify either \'next\' or \'previous\' in the \'direction\' column of the scenario data table"
  end
  puts "\nNow using the default \'tie\' and \'cufflinks\' that are displayed when the Match Tie and Cufflinks lightbox opens"
end

def set_initial_thumb_src_values
  @mtc_tie_thumb_photo_src[0] = @detailPage.mtc_tie_thumb_photo(@tie_item_code).src if @mtc_tie_thumb_photo_src.empty?
  @mtc_cufflinks_thumb_photo_src[0] = @detailPage.mtc_cufflinks_thumb_photo(@cufflinks_item_code).src if @mtc_cufflinks_thumb_photo_src.empty?
end

When /^I select the "(.*?)" display "(.*?)" navigation contol "(.*?)" number of times$/ do |product, direction, repetition_number|
  # Wait for the page elements in the MTC lightbox to appear before attempting to perform any tie or cufflink shifts
  @detailPage.wait_until_element_present(@detailPage.mtc_shirt_main_photo(@product_item_code))

  # Initialise values for displaying the item codes for tie & cufflinks
  @displayed_tie_code = FALSE
  @displayed_cufflinks_code = FALSE
  set_initial_thumb_src_values

  if product.downcase == TIE
    # extract the item code from the 'tie' and image's 'src' attribute and then store in an array for later use
	  if direction.downcase == NEXT

      ##################################################################################
      # perform the CUFFLINKS shift 'repetition_number' times for direction 'NEXT'.
      ##################################################################################
      repetition_number.to_i.times do
	      if !@tie_shift_disabled
          # perform the 'next' tie shift. The return value is TRUE if it was successful, FALSE if it fails.
          @tie_shift_disabled = @detailPage.mtc_change_tie(NEXT)
		      if @tie_shift_disabled
            @tie_shift_disabled_val = @tie_shift # if the shift failed then store the last tie shift executed.
		        puts "\nINFO: after #{@tie_shift} right shifts performed, the limit has been reached. Tie shift is now disabled"
          else
		        @tie_shift+=1 # increment the tie shift counter
            # Extract the item code from the 'tie' image's 'src' attribute and then store it in an array for later use
            @mtc_tie_thumb_photo_src.push(@detailPage.mtc_tie_thumb_photo(@tie_item_code).src)
            sleep 1
          end
        end
      end

    elsif direction.downcase == PREVIOUS

      ##################################################################################
      # perform the TIE shift 'repetition_number' times for direction 'PREVIOUS'.
      ##################################################################################
      repetition_number.to_i.times do
	      if !@tie_shift_disabled
          # perform the 'previous' tie shift. The return value is TRUE if it was successful, FALSE if it fails.
          @tie_shift_disabled = @detailPage.mtc_change_tie(PREVIOUS)
		      if @tie_shift_disabled
            @tie_shift_disabled_val = @tie_shift # if the shift failed then store the last tie shift executed.
            puts "\nINFO: after #{@tie_shift * -1} left shifts performed, the limit has been reached. Tie shift is now disabled"
          else
		        @tie_shift-=1 # decrement the tie shift counter
            # Extract the item code from the 'tie' image's
            # 'src' attribute and then store it in an array for later use
            @mtc_tie_thumb_photo_src.push(@detailPage.mtc_tie_thumb_photo(@tie_item_code).src)
            sleep 1
          end
        end
      end
		
	  else
      display_warning_msg(DIRECTION)
    end

  elsif product.downcase == CUFFLINKS
    # extract the item code from the 'cufflinks' image's 'src' attribute and then store in an array for later use
	  if direction.downcase == NEXT
      ##################################################################################
      # perform the CUFFLINKS shift 'repetition_number' times for direction 'NEXT'.
      ##################################################################################
      repetition_number.to_i.times do
	      if !@cufflinks_shift_disabled
          # perform the 'next' cufflinks shift. The return value is TRUE if it was successful, FALSE if it fails
          @cufflinks_shift_disabled = @detailPage.mtc_change_cufflinks(NEXT)
		      if @cufflinks_shift_disabled
            @cufflinks_shift_disabled_val = @cufflinks_shift # if the shift failed then store the last cufflinks shift executed.
            puts "\nINFO: after #{@cufflinks_shift} right shifts performed, the limit has been reached. Cufflinks shift is now disabled"
          else
		        @cufflinks_shift+=1 # increment the cufflinks shift counter
            # Extract the item code from the 'cufflinks' image's 'src' attribute and then store it in an array for later use
            @mtc_cufflinks_thumb_photo_src.push(@detailPage.mtc_cufflinks_thumb_photo(@cufflinks_item_code).src)
            sleep 1
          end
		    end
      end

	  elsif direction.downcase == PREVIOUS
      ##################################################################################
      # perform the CUFFLINKS shift 'repetition_number' times for direction 'PREVIOUS'.
      ##################################################################################
      repetition_number.to_i.times do
	      if !@cufflinks_shift_disabled
          # perform the 'previous' cufflinks shift. The return value is TRUE if it was successful, FALSE if it fails
          @cufflinks_shift_disabled = @detailPage.mtc_change_cufflinks(PREVIOUS)
		      if @cufflinks_shift_disabled
            @cufflinks_shift_disabled_val = @cufflinks_shift # if the shift failed then store the last cufflinks shift executed.
		        puts "\nINFO: after #{@cufflinks_shift * -1} left shifts performed, the limit has been reached. Cufflinks shift is now disabled"
          else
		        @cufflinks_shift-=1
            # Extract the item code from the 'cufflinks' image's 'src' attribute and then store it in an array for later use
            @mtc_cufflinks_thumb_photo_src.push(@detailPage.mtc_cufflinks_thumb_photo(@cufflinks_item_code).src)
            sleep 1
          end
        end
      end

    else
      display_warning_msg(DIRECTION)
    end

  else
    display_warning_msg(PRODUCT)
  end
end

And /^the "(.*?)" displayed shift "(.*?)" positions to the "(.*?)"$/ do |product, repetition_number, direction|
  direction_factor = 1
  direction_factor = -1 if direction == PREVIOUS

  if direction == NEXT || direction == PREVIOUS
    if product.downcase == TIE
      # verify that tie was shifted 'repetition_number' (eg. 5) times to the 'direction' (eg. next)
	    if !@tie_shift_disabled
	      @tie_shift.should == repetition_number.to_i * direction_factor
	    else
	      @tie_shift.should == @tie_shift_disabled_val
	    end
	    @mtc_tie_thumb_photo_src.each { |src| puts "\nTie item code displayed on carousel: \'#{src.split('/').last.sub('_tie.png','')}\'" }
      @displayed_tie_code = TRUE
    elsif product.downcase == CUFFLINKS
      # verify that cufflinks were shifted 'repetition_number' (eg. 5) times to the 'direction' (eg. next)
	    if !@cufflinks_shift_disabled
	      @cufflinks_shift.should == repetition_number.to_i * direction_factor
	    else
	      @cufflinks_shift.should == @cufflinks_shift_disabled_val
	    end
	    @mtc_cufflinks_thumb_photo_src.each { |src| puts "\nCufflinks item code displayed on carousel:  \'#{src.split('/').last.sub('_cuff.png','')}\'" }
      @displayed_cufflinks_code = TRUE
    end
  end
end

And /^I select Add To Basket for both items$/ do
  # Display the tie and cufflinks codes if they were not displayed in the last step definition
  # (due to an there being invalid value for any product, repetition_number or direction parameter in the scenario data table)
  if !@displayed_tie_code
    @mtc_tie_thumb_photo_src.each { |src| puts "\nTie item code displayed on carousel: \'#{src.split('/').last.sub('_tie.png','')}\'" }
  end
  if !@displayed_cufflinks_code
    @mtc_cufflinks_thumb_photo_src.each { |src| puts "\nCufflinks item code displayed on carousel:  \'#{src.split('/').last.sub('_cuff.png','')}\'" }
  end

  # Note how many items are in the basket BEFORE the tie and cufflinks are added.
  @qty_before = @detailPage.get_number_of_items_in_basket

  # Add the cufflinks to the basket.
  @detailPage.mtc_add_cufflinks_to_basket

  # Wait (default is up to PAGE_ELEMENT_TIMEOUT_SECS secs) until the cufflinks have been added to the basket
  time_secs = 0
  while time_secs < PAGE_ELEMENT_TIMEOUT_SECS
    break if @detailPage.get_number_of_items_in_basket != @qty_before
    sleep 1
    time_secs+=1
  end

  # Now add the tie to the basket.
  @detailPage.mtc_add_tie_to_basket
end

Then /^the selected Tie and Cufflinks are both added to the Basket$/ do
  # Wait until tie and cufflinks are added to the totals in the lightbox. Then close the lightbox
  @qty_added = @detailPage.mtc_qty_ties_in_basket + @detailPage.mtc_qty_cufflinks_in_basket
  @detailPage.mtc_close

  # Wait (default is up to PAGE_ELEMENT_TIMEOUT_SECS secs) until the items have been added to the basket
  time_secs = 0
  while time_secs < PAGE_ELEMENT_TIMEOUT_SECS
    break if @detailPage.get_number_of_items_in_basket == @qty_added + @qty_before
    sleep 1
    time_secs+=1
  end

  # Verify item total in basket is correct
  if @detailPage.get_number_of_items_in_basket != @qty_added + @qty_before
    puts "ERROR: The number of tie and cufflinks items in the basket is \'#{@qty_added}\' and should be \'#{@detailPage.get_number_of_items_in_basket}\'"
    @detailPage.get_number_of_items_in_basket.should == @qty_added + @qty_before
  end
end


