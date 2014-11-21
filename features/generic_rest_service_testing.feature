@wip
Feature: Test generic REST services
  As a client
  I would like to query the REST services
  So that I can use any data from available from REST services for my own purposes

  @cars
  Scenario: Send a find_XType GET request to the JagUK REST service
    Given I send a find_XType GET request with:
      | car    | price_cap | mileage_cap | max_age |
      | XType  | 30K       |  40K        | 3 years |
    Then I should receive a request was successful response code
    And the response should contain the following data:
      | reg_no   | price | class_no | colour | age      |
      | XC10 GTT | 25K   |    5     | red    | 2 years  |
      | XW10 GTT | 21K   |    4     | blue   | 2 years  |
      | XR10 GTT | 20K   |    4     | silver | 3 years  |


  Scenario Outline: Send a 'find_prog' GET request to the SKY TV REST service (SIMPLE BUT MORE STEP DEFS NEEDED)
  # Note: We don't know what data has been added to the REST service, only the data field names that should be returned for each response type
  # WE MAY NEED TO VERIFY THIS AGAINST A DATABASE
  # IMPORTANT: If there are multiple rows of output data returned for 1 GET request, then the each output field (eg. out_1) needs to be an array,
  # and the 'Scenarios' table could look rather messy when the array values are long strings!
    Given I send a find_prog GET request with "<username>" and "<password>", along with params "<current>","<subtitles>","<type>","<prog>" and "<avail>"
    Then I should receive a request was successful response code
    And I should receive a find_prog response which contains data that have the field names 'pid', 'title', 'format', 'description' and 'availability'
    And the find_prog response data records have the values "<pid_value>", "<title_value>", "<format_value>", "<description_value>" and "<availability_value>"

  Scenarios:
    | username | password | current | subtitles | type        | prog     | avail    |  pid_value  | title_value    | format_value     |    description_value       |    availability_value        |
    | adrian   | pass1    | no      | yes       | series_name | episode  | current  |  pid1, pid2 | title1, title2 | format1, format2 | description1, description2 | availability1, availability2 |
    | adrian   | pass1    | no      | no        | prog_name   | one-off  | no       |  pid1, pid2 | title1, title2 | format1, format2 | description1, description2 | availability1, availability2 |


  Scenario Outline: Send a 'generic' GET request to the SKY TV REST service (COMPLICATED BUT LESS STEP DEFS NEEDED. RESPONSE CAN BE A HASH, OR ARRAY OF HASHES)
  # Note: We don't know what data has been added to the REST service, only the data field names that should be returned for each response type
  # WE MAY NEED TO VERIFY THIS AGAINST A DATABASE
  Given I send a "<request_type>" GET request with "<username>" and "<password>", along with params "<request_name_value_pairs>"
  Then I should receive a request was successful response code
  And I should receive a "<response_type>" response which contain data records which have the fields and values "<response_field_name_and_values>"

  Scenarios:
    | username | password | request_type      | request_name_value_pairs                                                 | response_type    |   response_field_name_and_values                                                                                      |
    | adrian   | pass1    | find_prog         |   current:yes, subtitles:yes, type:series prog:episode, avail:current    | prog_list        |  [pid:val1, title:val1, formt:val1, desc:val1, avail:val1], [pid:val2, title:val2, formt:val2, desc:val2, avail:val2] |
    | adrian   | pass1    | find_cust_account |   cust_email, cust_id                                                    | cust_acc_details |  p1,p2,p3,p4,p5,p6,p7,p8,p9 |
