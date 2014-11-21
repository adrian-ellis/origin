Feature: Refer friends to ctshirts
  As a customer
  I would like to refer friends to ctshirts
  So that I can earn vouchers that give me discounts on future purchases that I may make.

  Scenario Outline: Refer 1 friend to ctshirts
    Given I login to My Account "<Account_Name>"
    And I navigate to Refer A Friend
    And my total number of friends is less than 10
    When I add a Friend
    Then the friend's name "<Name>" and email address "<Email_Address>" are saved in My Account "<Account_Name>"
    And my total number of my friends is incremented by 1
    And an email is sent to the friend's email address "<Email_Address>"

  Scenarios:
    | Account_Name   |     Name                             |     Email_Address                          |
    | test_account_1 |  random bloke                        |  random.dude@gmail.com                     |
    | test_account_1 |  random bloke with max-name-length   |  brandon.ude@gmail.com                     |
    | test_account_1 |  random bloke                        |  andon.xude@maximum-numberofcharacters.com |


  Scenario Outline: Refer multiple friends to ctshirts
    Given I login to My Account "<Account_Name>"
    And I navigate to Refer A Friend
    And my total number of friends is 0
    When I add 5 Friends
    Then the friends' names "<Name>" and email addresses "<Email_Address>" are saved in My Account "<Account_Name>"
    And my total number of my friends is 5
    And an email is sent to the friend's email address "<Email_Address>"

  Scenarios:
    | Account_Name   |     Name      |     Email_Address      |
    | test_account_1 |  random bloke |  random.dude@gmail.com |


  Scenario Outline: Refer a friend details provided are invalid
    Given I login to My Account "<Account_Name>"
    And I navigate to Refer A Friend
    And my total number of friends is less than 10
    When I add a Friend with invalid details within "<Name>" or email address "<Email_Address>"
    Then an error message is displayed
    And the friend's name "<Name>" and email address "<Email_Address>" are not saved in My Account "<Account_Name>"

  Scenarios:
    |   Account_Name   |         Name                                 |                   Email_Address                    |
    | test_account_1   |  averylongrandomnamethatis-1charactertoolong |  random.bob@gmail.com                              |
    | test_account_1   |  steve jobs-rip                              |  steve jobs-rip@theresnobodywithemailthislong.com  |
    | test_account_1   |  steve jobs-rip                              |  steve jobs-rip-nomail.pls                         |
    | test_account_1   |  steve jobs-rip                              |  steve jobs-rip@nomailpls                          |


  Scenario Outline: Refer more than 10 friends to ctshirts
    Given I login to My Account "<Account_Name>"
    And I navigate to Refer A Friend
    And my total number of friends is 10
    When I add 1 Friend
    Then the friend's name "<Name>" and email address "<Email_Address>" are not saved in My Account "<Account_Name>"
    And an error message is displayed
    And my total number of my friends is still 10
    And an email is not sent to the friends' email addresses "<Email_Address>"

  Scenarios:
    | Account_Name   |     Name      |     Email_Address      |
    | test_account_1 |  random bloke |  random.dude@gmail.com |



  Scenario: Remove 1 friend from Friend list ??????
  Scenario: Claim voucher obtained when friend buys goods >= £ammount from ctshirts
  Scenario: Claim voucher is not obtained when friend buys goods < £ammount from ctshirts
  Scenario: Purchase goods with Claim voucher obtained from refer a friend scheme
