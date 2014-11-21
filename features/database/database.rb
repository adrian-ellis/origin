###########################################
## Connect to db
###########################################
#ActiveRecord::Base.establish_connection(
#    :adapter => 'sqlite3',
#    :database => BASE_INSTALL_DIR + '/features/database/sales.db')
##############ActiveRecord::Base.logger = Logger.new(STDERR)
###############puts "b4 incl SalesDatabaseTables, current dir is #{Dir.pwd}\n"
#include SalesDatabaseTables
#
#
#########################################################
## Insert data into tables (using Active Record)
#########################################################
#new_user = Users.new(:user_id => 3, :username => 'fred01', :passwd => 'psw5', :first_name => 'fred', :last_name => 'better', :email => 'fred_better555@hotmail.com')
#new_user.save
#
#Address.create(:user_id => 1, :full_address => '16 Laurel Cres, Woking, Surrey')
#Address.create(:user_id => 2, :full_address => '303 Gateway Rd, Guildford, Surrey')
#Address.create(:user_id => 3, :full_address => '1 Oxford Street, London')
#Products.create(:product_id => 'CX5467RL', :product_name => 'red Xdb print casual shirt (L)', :price => 29.99)
#Products.create(:product_id => 'YT2956XL', :product_name => 'acid yellow flouro-glow tank top (XL)', :price => 34.99)
#Products.create(:product_id => 'SN7496UC', :product_name => 'black urban camo sneakers (L)', :price => 89.99)
#Products.create(:product_id => 'CX5467RL', :product_name => 'GSX1500 leather jacket (L)', :price => 349.99)
#LineItem.create(:user_id => 1, :order_id => 341, :product_id => 'CX5467RL', :quantity => 1 , :total_price => 349.99)
#Orders.create(:customer_name => 'janet smith', :full_address => '303 Gateway Rd, Guildford, Surrey', :email => 'jan_smith8595@msn.com', :pay_type => 'cc', :order_id => 341, :order_amount => 349.99, :shipped_date => Date.today)
#puts "done all new record calls\n"
#
## query this db
#users = Users.all.order :user_id
#puts "AFTER:"
#users.each { |record| puts record.user_id, record.username , record.email}
#
