require "httparty"
require "sfdc-connect"

module SfdcConnect
  class Account < BaseSfdcObject
    include HTTParty
    extend ResponseValidator
  end  
end