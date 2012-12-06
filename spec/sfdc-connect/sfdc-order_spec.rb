require File.dirname(__FILE__) + "/../spec_helper.rb"
require 'sfdc-order'

describe SfdcConnect::Order do
  it "should retrieve a list of orders for an account" do
    orders = SfdcConnect::Order.orders_for_account("001V0000006FAyB")
    PP.pp orders
    orders.should_not be nil    
  end
end