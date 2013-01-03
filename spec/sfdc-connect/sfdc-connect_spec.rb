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

describe SfdcConnect::BaseSfdcObject do
  before(:all) do
    class TestQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
    end

    @account = TestQuery.find "001V0000006FAyBIAW"  
  end

  it "tie query results to method calls." do
    @account = TestQuery.find "001V0000006FAyBIAW"        
    expect(@account.respond_to?(:name)).to be true
    expect(@account.respond_to?(:foozle)).to be false    
    expect(@account.name).to eq "Saratech Inc."
  end

  it "Test alternate method name support" do
    @account = TestQuery.find "001V0000006FAyBIAW"        
    expect(@account.respond_to?(:numberofemployees)).to be true    
    expect(@account.respond_to?(:number_of_employees)).to be true    
    expect(@account.numberofemployees).to eq 30    
    expect(@account.number_of_employees).to eq 30
  end

  it "Should correctly convert iso8601 dates to DateTime objects" do
    @account = TestQuery.find "001V0000006FAyBIAW"    
    expect(@account.created_date.kind_of?(DateTime)).to be true
    expect(@account.compliance_expiration_date.kind_of?(DateTime)).to be true
    expect(@account.dnb_report_date.kind_of?(DateTime)).to be true
  end

  it "Should provide access to metadata" do
    metadata = TestQuery.metadata    
    expect(metadata).not_to be nil
  end

  it "Should provide access to field names" do
    field_names = TestQuery.field_names    
    expect(field_names).not_to be nil    
    expect(field_names.include?("Id")).to be true    
    expect(field_names.include?("Name")).to be true

  end
end