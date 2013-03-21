require_relative "../spec_helper.rb"
require 'sfdc-account'

describe SfdcConnect::Account do
  # it "should description fetch a single account" do
  #   account = SfdcConnect::Account.find("001V0000006FAyB")
  #   account.should_not be nil    
  # end

  # it "Should be able to retrieve a list of all exsting accounts" do
  #   accounts = SfdcConnect::Account.all
  #   PP.pp accounts
  #   accounts.should_not be nil

  # end

  it "Should fetch an account by SAP payer id" do
    account = SfdcConnect::Account.account_by_payer_id('4062313')
    expect(account.sap_payer_id).to eq '4062313'
  end

end