require "httparty"
require "sfdc-object"

module SfdcConnect
  class Account < BaseSfdcObject
    include HTTParty
    extend ResponseValidator
  end  
end