require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require File.dirname(__FILE__) + "/../config/sfdc-connect-config.rb"

def check_date(date_as_string, year, month, day)
  date = DateTime.parse(date_as_string)
  date.year.should be year
  date.month.should be month
  date.day.should be day
end