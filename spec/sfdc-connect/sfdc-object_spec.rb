require File.dirname(__FILE__) + "/../spec_helper.rb"
require "sfdc-object"

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