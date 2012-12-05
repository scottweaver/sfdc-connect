require File.dirname(__FILE__) + "/../spec_helper.rb"
require File.dirname(__FILE__) + "/../../config/sfdc-connect-config.rb"


require "sfdc-connect"

describe SfdcConnect::Authenticator do
  it "Should be able to get the authentication token" do
    auth = SfdcConnect::Authenticator.new
    auth.authenticate.should_not be nil

  end

  it "Should handle failures" do
    creds = SfdcConnect::Credentials.new(
      "----",
      "xxxx",
      "xxxxx",
      "xxxxxx")
    auth = SfdcConnect::Authenticator.new
    expect { auth.authenticate(creds) }.to raise_error
  end
end