require_relative "../spec_helper.rb"
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

