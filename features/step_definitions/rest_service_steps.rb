Given /^I send a GET request to the geocode REST Service specifying '([^\"]*?)' as an input parameter$/ do |search_address|
#  request_url = 'https://www.google.co.uk/search'
#  query_string = '?tbm=map&fp=1&authuser=0&hl=en&pb=!4m12!1m3!1d2718616.7528794543!2d-2.3278149499999996!3d52.83820044999999!2m3!1f0!2f0!3f0!3m2!1i1760!2i423!4f13.1!10b1!12m3!2m1!20e3!16b1!19m7!1e1!1e2!1e5!1e9!1e10!1e12!4smaps_sv.tactile!20m13!1e1!1e2!1e5!1e11!1e4!1e3!1e9!1e10!1e12!2m2!1i203!2i100!5smaps_sv.tactile!22m4!1sv0nFU7riDcOq0QW9-oG4DQ!4m1!2i5355!7e81!26m4!1e12!1e13!1e3!4smaps_sv.tactile!30m28!1m6!1m2!1i0!2i0!2m2!1i450!2i423!1m6!1m2!1i1710!2i0!2m2!1i1760!2i423!1m6!1m2!1i0!2i0!2m2!1i1760!2i20!1m6!1m2!1i0!2i403!2m2!1i1760!2i423&q=tw8%209de&oq=tw8%209de&gs_l=maps.12..38i69.66119.73479.1.80771.8.8.0.0.0.0.1748.2696.0j5j1j8-1.7.0....0...1ac.1.40.maps..1.7.2696.3.&tch=1&ech=1&psi=v0nFU7riDcOq0QW9-oG4DQ.1405438402272.1'
#  hash_string = {:params => {:tbm => 'map', :fp => 1, :authuser => 0, :hl => 'en', :pb =>'!4m12!1m3!1d2718616.7528794543!2d-2.3278149499999996!3d52.83820044999999!2m3!1f0!2f0!3f0!3m2!1i1760!2i423!4f13.1!10b1!12m3!2m1!20e3!16b1!19m7!1e1!1e2!1e5!1e9!1e10!1e12!4smaps_sv.tactile!20m13!1e1!1e2!1e5!1e11!1e4!1e3!1e9!1e10!1e12!2m2!1i203!2i100!5smaps_sv.tactile!22m4!1sv0nFU7riDcOq0QW9-oG4DQ!4m1!2i5355!7e81!26m4!1e12!1e13!1e3!4smaps_sv.tactile!30m28!1m6!1m2!1i0!2i0!2m2!1i450!2i423!1m6!1m2!1i1710!2i0!2m2!1i1760!2i423!1m6!1m2!1i0!2i0!2m2!1i1760!2i20!1m6!1m2!1i0!2i403!2m2!1i1760!2i423', :q => 'tw8%209de', :oq => 'tw8%209de', :gs_l => 'maps.12..38i69.66119.73479.1.80771.8.8.0.0.0.0.1748.2696.0j5j1j8-1.7.0....0...1ac.1.40.maps..1.7.2696.3.', :tch => 1, :ech => 1, :psi=> 'v0nFU7riDcOq0QW9-oG4DQ.1405438402272.1'}}
#  @response = RestClient.get(request_url, hash_string)

  # send the HTTP GET using RestClient
  request_url = 'https://maps.googleapis.com/maps/api/geocode/json'
  hash_string = {:params => {:address => search_address, :sensor => 'false'}}
  @response = RestClient.get(request_url, hash_string)

#
#  *** RestClient methods from the module ***
#  module RestClient
#
#    def self.get(url, headers={}, &block)
#      Request.execute(:method => :get, :url => url, :headers => headers, &block)
#    end
#
#    def self.post(url, payload, headers={}, &block)
#      Request.execute(:method => :post, :url => url, :payload => payload, :headers => headers, &block)
#    end
#
#    def self.patch(url, payload, headers={}, &block)
#      Request.execute(:method => :patch, :url => url, :payload => payload, :headers => headers, &block)
#    end
#
#    def self.put(url, payload, headers={}, &block)
#      Request.execute(:method => :put, :url => url, :payload => payload, :headers => headers, &block)
#    end
#
#    def self.delete(url, headers={}, &block)
#      Request.execute(:method => :delete, :url => url, :headers => headers, &block)
#    end
#
#  end
#
# def self.head(url, headers={}, &block)
#    Request.execute(:method => :head, :url => url, :headers => headers, &block)
#  end
#
#  def self.options(url, headers={}, &block)
#    Request.execute(:method => :options, :url => url, :headers => headers, &block)
#  end
end

Given /^I send a GET request to the geocode REST Service specifying '([^\"]*?)' and '([^\"]*?)' as input parameters$/ do |search_address, postcode|
  postcode_str = "postal_code:#{postcode}"
  request_url = 'https://maps.googleapis.com/maps/api/geocode/json'

  # send the HTTP GET using RestClient
  hash_string = {:params => {:address => search_address, :address_components => postcode_str, :sensor => 'false'}}
  @response = RestClient.get(request_url, hash_string)
end

Given /^I send a find_XType GET request with:$/ do |table|
#  puts "car = #{table[:car]}"
  table.hashes.each { |hash| puts "#{hash}" }
#  puts "#{table.hashes.first}"
#  puts "car = #{table[:price_cap]}"
#  puts "car = #{table[:mileage_cap]}"
#  puts "car = #{table[:max_age]}"
#  @response = nil
end

Given /^I send a RecentlyWatched GET request to the BBC iPlayer REST service$/ do
  puts "in BBC REST Given step\n"
  # send the HTTP GET using RestClient
  request_url = 'http://www.bbc.co.uk/iplayer/usercomponents/recentlywatched'
  cookies = { :cookies => { :BGUID => "748c08f515f2fa189990de9a0149b1e467ba2d1c20b0b1c73ac4f89dfb750d68" } }

  @response = RestClient.get(request_url, cookies)  # use url and params
end

Given /^I send (\d+) '([^"]*)' requests? to the Jobserve REST service$/ do |num_requests, request_type|
  case request_type
    when 'jobsearch_POST'
      # JOBSERVE working example 1
      jobserve_JobSearch_post_url = 'https://www.jobserve.com/WebServices/JobSearch.asmx/RetrieveJobs?shid=16376022FEB1A2A522'
      json_hash = {pageNum: "1", jobIDsStr: "9CD39FBE1F99E101#A03598230FED323B#F8C0F2AEC7EC9863#1C2F1E6F7B43BDAD#C78A7FE0F45A08A3#1A2DE3AA613B93A7#B9285F64F28C9C66#4B5AEFD408093B32#4AE9F3E621941728#18E2961C97BD7692#DFCDA5130C2AD91A#39BE63726229478F#FCB3B0BD6308A5F3#8A2F99461186E056#2CDA5C1AD3D1E9DF#DED57233597E1759#60C219BFC3074075#E04F0A1FF750F4EF#8E0E9AEEF94D0482#F8562389F35F8D0C#D70C585900E5D28D"}

      # read in the JSON data from a file (Note: the JSON data has the default parameters)
      fname = %Q(features/data_files/#{request_type}.json)
      json_data = IO.read(fname)

      # If needed, format the key parts of the JSON data, so they appear as {key: "value"} instead of {"key": "value"}
      json_data.gsub!(/"([^"]+)":/, '\1: ')

      # removes the '\' chars from the data. But we still cannot submit a string as JSON data. There's no way to remove string quotes or convert string to a hash.
      json_data.gsub! %(\"),''

      # update the default paramaters in JSON string (if we need to)
      # eg. json_data.gsub(/\"#{default_value}\"/,%Q("#{new_value}"))
      #jobIDsStr = "9CD39FBE1F99E101#A03598230FED323B#F8C0F2AEC7EC9863#1C2F1E6F7B43BDAD#C78A7FE0F45A08A3#1A2DE3AA613B93A7#B9285F64F28C9C66#4B5AEFD408093B32#4AE9F3E621941728#18E2961C97BD7692#DFCDA5130C2AD91A#39BE63726229478F#FCB3B0BD6308A5F3#8A2F99461186E056#2CDA5C1AD3D1E9DF#DED57233597E1759#60C219BFC3074075#E04F0A1FF750F4EF#8E0E9AEEF94D0482#F8562389F35F8D0C#D70C585900E5D28D"
      #pageNum = "1"
      num_requests.times { comment = 0 }

      # execute the POST request
      @response = RestClient.post(jobserve_JobSearch_post_url, json_hash)
    when 'UpdatePolling_GET'
      # JOBSERVE working example 2 - need to send a cookie here, or we get a response code of 403 (Forbidden)
      jobserve_UpdatePolling_get_url = 'https://www.jobserve.com/signalr?transport=longPolling&connectionToken=LRwOyCsiBxCgaMDCeLhIdUBUy3DltGDTXPuQsvOaojYOfIAjecTq3vyaLk-Hz6YXiGO62JJPzL1Q0RNHb49cDvrDNdMUD4WxVo4HsjSRkwHW_OTGewBkLVzJYI1YGSMh0&connectionData=%5B%7B%22name%22%3A%22messagehub%22%7D%5D&groupsToken=UunIJvUoLWnVK7Up0w-7fP8RGinJrPj1aH8aWbV4r_x32J49A6RDvLB_nc-qBOIDLiMev_DMHc0l6QEEmp1pyE41bQX4JP4R6WiDeEb48KeTInMgv3snXbxKX37qZxWB0&messageId=B%2C0%7CB8mZ%2C0%7CB8ma%2C1%7CB8mb%2C0%7CB6JE%2C0&tid=4&_=1405692624691'
      jobserve_UpdatePolling_auth_cookie = { :cookies => { :JSFX => 'D904FC21-12E3-454D-97D8-BAF2EB2E5CAC' }}
      @response = RestClient.get(jobserve_UpdatePolling_get_url, jobserve_UpdatePolling_auth_cookie)
      # Parses JSON response into a ruby hash so we can inspect the data this way
      JSON.parse(@response)
  end

  # TWITTER example wip
  twitter_rest_url = 'https://twitter.com/i/profiles/show/TechGuru008/timeline.json?composed_count=0'
end

Then /^I should receive a request was successful response code$/ do
  Not_Expect(@response == nil)
  expect(@response.code).to eql 200
  Expect(@response.code == 200)
end

And /^the response header contains valid data$/ do
  # check we get some header data, and it's in a hash format
  Not_Expect(@response.headers == nil)
  Expect(@response.headers.is_a? Hash)

  # Inspect header data
  puts "Response Header = #{@response.headers}"
end

And /^the response contains valid JSON data$/ do
  # check we get some data, and it's not in a hash format
  Not_Expect(@response == nil)
  Expect(@response.is_a? String)

  ### use JsonPath to inspect the data. ###
  # Note the data returned from JsonPath.on() is an array.
  # The first value in the array (ie. json[0] ) contains all the JSON data we asked for using json = JsonPath.on(@response, pathname)
  # where 'pathname' is search path we specified within the JSON doc @response'.
  # The rest of the values correspond to each of the JSON key/values contained within json[0] (if they're are any present)

  #Expect(JsonPath.on(@response,'e').size == 1)
  #e_value = JsonPath.on(@response,'e')[0]
  #puts "e = #{e_value}"
  #
  #e_query = find_json_obj(@response,'e')
  #puts "#{e_query}"
  #
  #Expect(JsonPath.on(@response,'c').size == 1)
  #c_value = JsonPath.on(@response,'c')[0]
  #puts "c = #{c_value}"
  #
  #Expect(JsonPath.on(@response,'p').size == 1)
  #p_value = JsonPath.on(@response,'p')[0]
  #puts "p = #{p_value}"
  #
  #Expect(JsonPath.on(@response,'u').size == 1)
  #u_value = JsonPath.on(@response,'u')[0]
  #puts "u = #{u_value}"
  #
  #Expect(JsonPath.on(@response,'d').size == 1)
  #d_value = JsonPath.on(@response,'d')[0]
  ##puts "d = #{d_value}"
end

And /^the following data '([^\']*?)', '([^\']*?)', '([^\']*?)', '([^\']*?)', '([^\']*?)', '([^\']*?)', '([^\']*?)' and '([^\']*?)' are contained in the response$/ do |formatted_address,route,locality,postal_town,administrative_area,country,postal_code,location_type|
  puts @response
  puts "\nTHE END\n"
  str = JsonPath.on(@response,'$..formatted_address')[0].downcase; puts "#{str}\n"
  str = JsonPath.on(@response,"$..address_components[1]['long_name']")[0].downcase; puts "#{str}\n"
  str = JsonPath.on(@response,"$..address_components[2]['long_name']")[0].downcase; puts "#{str}\n"
  str = JsonPath.on(@response,"$..address_components[3]['long_name']")[0].downcase; puts "#{str}\n"
  str = JsonPath.on(@response,"$..address_components[4]['long_name']")[0].downcase; puts "#{str}\n"
  str = JsonPath.on(@response,"$..address_components[5]['long_name']")[0]; puts "#{str}\n"
  str = JsonPath.on(@response,"$..location_type")[0]; puts "#{str}\n"

  # Verify the JSON response data contains the expected values (using JsonPath to identify the values we need)
  Expect(JsonPath.on(@response,'$..formatted_address')[0].downcase.include? formatted_address)
  Expect(JsonPath.on(@response,"$..address_components[0]['long_name']")[0].downcase == route)
  Expect(JsonPath.on(@response,"$..address_components[1]['long_name']")[0].downcase == locality)
  Expect(JsonPath.on(@response,"$..address_components[2]['long_name']")[0].downcase == postal_town)
  Expect(JsonPath.on(@response,"$..address_components[3]['long_name']")[0].downcase == administrative_area)
  Expect(JsonPath.on(@response,"$..address_components[4]['long_name']")[0].downcase == country)
  Expect(JsonPath.on(@response,"$..address_components[5]['long_name']")[0] == postal_code)
  Expect(JsonPath.on(@response,"$..location_type")[0] == location_type)
end

And /^the response contains the last few programs I watched on iPlayer$/ do
  # Parse the JSON response data into a ruby hash
  json_data_hash = JSON.parse(@response)

  # Output the 'HTML' key's value for proof of getting some useful data
  responses_html = json_data_hash['html'].gsub(/<div/,"\n<div").gsub(/<li/,"\n<li")
  puts "#{responses_html}\n"
end

And /^the response should contain the following data:$/ do |table|
#pending
end
