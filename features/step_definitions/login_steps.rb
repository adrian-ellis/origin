When /^I login with "(.*)" and "(.*)"$/ do |email_addr, password|
  # the country_specific step file contains the code to open the homepage
  # and return an instance of 'HomePage'
  @loginPage = @homePage.visit_loginpage
  @loginPage.login_with(email_addr, password)
end

Then /^the login is successful$/ do
  Expect @loginPage.login_succeeded
  @myAccountPage = MyAccountPage.new(page,@country)
end

Then /^my home page is displayed$/ do
  expect(@myAccountPage.page_url).to include("Preferences")
  Expect @myAccountPage.account_link_is_present
  Expect @myAccountPage.page_heading_is_present
end

Then /^the login fails$/ do
  Not_Expect @loginPage.login_succeeded
end

Then /^the error message "(.*)" is displayed$/ do |message|
  expect(@loginPage.error_message_displayed).to eql message
end

And /^And the login page is still displayed$/ do
  #pending
end

