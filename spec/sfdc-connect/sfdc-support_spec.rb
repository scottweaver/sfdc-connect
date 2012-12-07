require File.dirname(__FILE__) + "/../spec_helper.rb"
require 'sfdc-support'

class TestHarness
  extend SfdcConnect::DateAssistant
end

describe SfdcConnect::DateAssistant do
  it "Validate multiple date formats" do
    dates=["2011-12-20T22:38:57.000+0000",
            "08/10/2005",
            "12/31/2005",
            "2006-06-02",
            "2010-11-13"]

    dates.each do |date|
      p "Testing date: #{date}"
      TestHarness.date?(date).should be true
     end

    ["13/31/2005"].each do |not_date|
      p "Testing NOT date: #{not_date}"
      TestHarness.date?(not_date).should be false
    end

    check_date(dates[0], 2011, 12, 20)
    check_date(dates[1], 2005, 10, 8)
    check_date(dates[3], 2006, 6, 2)

  end
end