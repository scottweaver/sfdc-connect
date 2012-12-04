require File.dirname(__FILE__) + "/../spec_helper.rb"
require File.dirname(__FILE__) + "/../../config/sfdc-connect-config.rb"


require "sfdc-connect"

describe SfdcConnect::Authenticator do
  it "Should be able to get the authentication token" do
    auth = SfdcConnect::Authenticator.new
    auth.authenticate.should == EXPECTED_TOKEN

  end

end