require File.dirname(__FILE__) + "/../spec_helper.rb"
require "sfdc-connect"

describe SfdcConnect::Authenticator do
  it "Should be able to get the authentication token" do
    token = SfdcConnect::Authenticator.authenticate
    p token
    token.should_not be nil
  end

  it "Should handle failures" do
    creds = SfdcConnect::Credentials.new(
      "----",
      "xxxx",
      "xxxxx",
      "xxxxxx")
    expect { SfdcConnect::Authenticator.authenticate(creds) }.to raise_error
  end

  it "Should be able to set an application-level access_token" do
    token = SfdcConnect::Authenticator.authenticate
    SfdcConnect::Authenticator.set_access_token
    SfdcConnect.access_token.should == token
  end
end

describe SfdcConnect::SfdcRESTQuery do
  it "Retrieve an object by id" do    
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end
    account = TestQuery.retrieve "001V0000006FAyBIAW"
    account.should_not be nil    
    PP.pp account
    account["Name"].should == "Saratech Inc."
  end

  it "Should handle SOQL queries" do
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end
    accounts = TestQuery.search "Select Id, Name from Account where Name ='Saratech Inc.'"
    accounts.should_not be nil  
    PP.pp accounts 
    accounts[0]['Id'].should == "001V0000006FAyBIAW"
  end
end

describe SfdcConnect::BaseSfdcObject do
  it "tie query results to method calls." do
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end
    sobject = TestQuery.retrieve "001V0000006FAyBIAW"
    account = SfdcConnect::BaseSfdcObject.new(sobject)
    account.respond_to?(:name).should be true
    account.respond_to?(:foozle).should be false
    account.name.should == "Saratech Inc."
  end
end