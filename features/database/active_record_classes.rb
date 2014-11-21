#module SalesDatabaseTables
## User table
#class Users < ActiveRecord::Base
#  self.primary_key = :user_id
#  validates :user_id, uniqueness: true
#  validates :email, uniqueness: true
#
#  has_many :addresses
#end
#
## Address table
#class Address < ActiveRecord::Base
#  self.table_name = :addresses
#  self.primary_key = :user_id
#  validates :user_id, uniqueness: true
#
#  belongs_to :users
## delegate method(s) to a another class (via a database table relation)
##  extend Forwardable
##  def_delegators :users, :email
#end
#
#class Products < ActiveRecord::Base
#  self.primary_key = :product_id
#
#  validates :product_id, uniqueness: true
#
#  has_many :lineitems
#end
#
## In the file order.rb
#class Orders < ActiveRecord::Base
#  self.primary_key = :order_id
#
#  validates :order_id, uniqueness: true
#
#  has_many :lineitems
#end
#
#######################################################################
## Define the default data for a new order
##Factory.define :order do |record|
##  record.name "cheezy"
##  record.address "123 main"
##  record.email "cheezy@example.com"
##  record.pay_type "cc"
##end
#######################################################################
#
## In the file line_item.rb
#class LineItem < ActiveRecord::Base
#  self.table_name = :lineitems
#  self.primary_key = :order_id
#
#  belongs_to :orders
#  belongs_to :products
#end
#end
#
