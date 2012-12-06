require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require File.dirname(__FILE__) + "/../config/sfdc-connect-config.rb"
