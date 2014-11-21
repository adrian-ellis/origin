#require 'active_record'
#require 'sqlite3'
#
#BASE_INSTALL_DIR = 'C:/Ruby193/ctproject'
#DATABASE_INSTALL_DIR = BASE_INSTALL_DIR + %(/features/database/)
#SALES_DATABASE_FILE = DATABASE_INSTALL_DIR + 'sales.db'
#
#def create_db_tables
#  # Create the tables
#  if (!File.file? SALES_DATABASE_FILE)
#    db = SQLite3::Database.new SALES_DATABASE_FILE
#    db.execute 'CREATE TABLE Users (user_id INT, username VARCHAR(25), passwd VARCHAR(25), first_name VARCHAR(25), last_name VARCHAR(25), email VARCHAR(25))'
#    db.execute 'CREATE TABLE Addresses (user_id INT, full_address VARCHAR(100))'
#    db.execute 'CREATE TABLE Products (product_id VARCHAR(25), product_name VARCHAR(50), price DECIMAL(8.2))'
#    db.execute 'CREATE TABLE LineItems (user_id INT, order_id INT, product_id VARCHAR(25), quantity INT, total_price DECIMAL(8.2))'
#    db.execute 'CREATE TABLE Orders (customer_name VARCHAR(50), full_address VARCHAR(100), email VARCHAR(50), pay_type VARCHAR(20), order_id INT, order_amount DECIMAL(8.2), shipped_date DATE)'
#
#    # Insert data into tables (using SQL)
#    db.execute 'INSERT INTO users (user_id,username,passwd,first_name,last_name,email) VALUES (1,"adrian_ellis","red","adrian","ellis","adrian_ellis232@bt.com")'
#    db.execute 'INSERT INTO users (user_id,username,passwd,first_name,last_name,email) VALUES (2,"janetrd3","jan01","janet","smith","jan_smith8595@msn.com")'
#    puts "'SELECT * FROM Users'\n#{db.execute 'SELECT * FROM Users'}"
#  end
#end
#
#create_db_tables
#
