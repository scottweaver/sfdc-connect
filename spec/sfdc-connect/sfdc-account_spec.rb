require File.dirname(__FILE__) + "/../spec_helper.rb"
require 'sfdc-account'

describe SfdcConnect::Account do
  it "should description fetch a single account" do
    account = SfdcConnect::Account.retrieve("001V0000006FAyB")
    account.should_not be nil    
  end

  # it "Should be able to retrieve a list of all exsting accounts" do
  #   accounts = SfdcConnect::Account.all
  #   PP.pp accounts
  #   accounts.should_not be nil

  # end

end