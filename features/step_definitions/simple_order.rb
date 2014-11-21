Given /^I am logged into my account as "([^""]*)"$/ do |user|
  # confirm username exists
  Expect (Users.exists?(username: user))

  # find user_id
  @user_id = Users.find_by_username(user).user_id
end

And /^I create an order for:$/ do |table|
  # create new order_id
  @new_order_id = Orders.maximum(:order_id) + 1

  # go through each row in the scenario's data table
  table.hashes.each do |row|
    Decimal price = 0
    Decimal total_price = 0

    product = row[:product]
    quantity = row[:quantity]

    # confirm product in current row exists
    Expect(Products.exists?(product_id: product))

    # find price for current row. calculate total price (where qty > 1)
    price = Products.find_by_product_id(row[:product]).price.round(2)
    total_price = price * quantity

    # create data for the new order in the LineItem table. create 1 row for each row in the scenario's data table.
    LineItem.create(:user_id => @user_id, :order_id => @new_order_id, :product_id => row[:product], :quantity => quantity, :total_price => total_price)
    LineItem.order(:order_id).all.each { |items| puts "#{items.user_id} | #{items.order_id} | #{items.product_id} | #{items.quantity} | #{items.total_price}"}
  end
end

When /^I pay for the order by "([^""]*)"$/ do |payment_method|
  Decimal order_amount = 0

  # find rows in LineItem table corresponding to the order id, then calculate the accumulative total price for all the items
  line_item = LineItem.where(:user_id => @user_id, :order_id => @new_order_id).all
  line_item.each {|item| order_amount += item.total_price}

  # find name, address, email for customer's order
  name = Users.where(:user_id => @user_id).first.username
  email = Users.where(:user_id => @user_id).first.email
  address = Address.where(:user_id => @user_id).first.full_address

  # create the new order in the LineItem table
  Orders.create(:customer_name => name, :full_address => address, :email => email, :pay_type => payment_method, :order_id => @new_order_id, :order_amount => order_amount, :shipped_date => Date.today)
end

Then /^my order is confirmed as being shipped$/ do
  expect(Orders.where(:order_id => @new_order_id).first.shipped_date).to eq(Date.today)
  Orders.all.each { |order| puts "#{order.customer_name} | #{order.full_address} | #{order.email} | #{order.pay_type} | #{order.order_id} | #{order.order_amount} | #{order.shipped_date}"}
end


