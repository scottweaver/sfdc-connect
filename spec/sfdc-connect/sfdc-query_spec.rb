require_relative "../spec_helper.rb"
require "sfdc-query"

describe SfdcConnect::SfdcRESTQuery do
  before(:all) do
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end

    @account = TestQuery.find "001V0000006FAyBIAW" 
  end

  it "find an object by id" do    
    @account = TestQuery.find "001V0000006FAyBIAW"
    expect(@account).to_not be nil    
    expect(@account.name).to eq "Saratech Inc."

  end

  it "Should handle SOQL queries" do
    @accounts = TestQuery.search "Select Id, Name from Account where Name ='Saratech Inc.'"
    expect(@accounts).not_to be nil
    expect(@accounts[0]['Id']).to eq "001V0000006FAyBIAW"
  end

  it "Should support a simple 'where' method like ActiveRecord" do
    
  end
end