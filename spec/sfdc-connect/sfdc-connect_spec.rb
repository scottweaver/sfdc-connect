require File.dirname(__FILE__) + "/../spec_helper.rb"
require "sfdc-connect"

describe SfdcConnect::Authenticator do
  it "Should be able to get the authentication token" do
    token = SfdcConnect::Authenticator.authenticate
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
    account.name == "Saratech Inc."
  end

  it "Should handle SOQL queries" do
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end
    accounts = TestQuery.search "Select Id, Name from Account where Name ='Saratech Inc.'"
    accounts.should_not be nil  
    accounts[0]['Id'].should == "001V0000006FAyBIAW"
  end
end

describe SfdcConnect::BaseSfdcObject do
  it "tie query results to method calls." do
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end
    account = TestQuery.retrieve "001V0000006FAyBIAW"    
    account.respond_to?(:name).should be true
    account.respond_to?(:foozle).should be false
    account.name.should == "Saratech Inc."
  end

  it "Test alternate method name support" do
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end

    account = TestQuery.retrieve "001V0000006FAyBIAW"    
    account.respond_to?(:numberofemployees).should be true
    account.respond_to?(:number_of_employees).should be true
    account.numberofemployees.should == 30
    account.number_of_employees.should == 30
  end

  it "Should correctly convert iso8601 dates to DateTime objects" do
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end
    account = TestQuery.retrieve "001V0000006FAyBIAW"    
    account.created_date.kind_of?(DateTime).should be true
    account.compliance_expiration_date.kind_of?(DateTime).should be true
    account.dnb_report_date.kind_of?(DateTime).should be true
  end
end