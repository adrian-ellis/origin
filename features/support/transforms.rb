# Transform used to convert the 'number strings' (eg. '99' or '-99') in the step def's regular expression to integers (eg. 99 or -99)
Transform /^-?\d+$/ do |number|
  number.to_i
end

# Transform used for better data table access. This example works for a table of 'users' and 'followers'.
# It operates on the Cucumber table object (after the step def regular expression is macthed?)
Transform /^table:user,followers$/ do |table|
  table.map_headers! {|header| header.downcase.to_sym }
  table.map_column!(:user) {|user| User.find_by_name(user) }
  table.map_column!(:followers) {|count| count.to_i }
  table
end

# Expt for the JAG XK REST service feature
Transform /^table:car,price_cap,mileage_cap,max_age$/ do |table|
  table.map_headers! {|header| header.downcase.to_sym }
  table.map_column!(:car) {|car| %Q(Jag #{car}) }
  table.map_column!(:price_cap) {|val| (val.to_i)*1000 }
  table.map_column!(:mileage_cap) {|val| (val.to_i)*1000 }
  table.map_column!(:max_age) {|val| p = val.match /(\d+)/; p[1] }
end

Transform /^table:quantity,product$/ do |table|
  table.map_headers! {|header| header.downcase.to_sym }
  table.map_column!(:quantity) {|quantity| quantity.to_i}
end