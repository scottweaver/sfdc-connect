require "sfdc-connect/version"
require 'httparty'
require "cgi"
require "sfdc-support"

module SfdcConnect
  require "sfdc-query"

  class << self
    attr_accessor :sfdc_login_url, :default_credentials, :sfdc_instance_url, :access_token
  end
  
  class Authenticator
    include HTTParty
    extend ResponseValidator

    def self.authenticate(credentials=SfdcConnect.default_credentials)
      response = self.post(SfdcConnect.sfdc_login_url,
        query: credentials.to_hash)   
      validate_response(response)
      response["access_token"]
    end

    def self.set_access_token(credentials=SfdcConnect.default_credentials)
      SfdcConnect.access_token = authenticate(credentials)
    end
  end

  class Credentials
    attr_reader  :client_id, :client_secret, :username, :password, :grant_type

    def initialize(client_id, client_secret, username, password)
      @client_id = client_id
      @client_secret = client_secret
      @username = username
      @password = password
      @grant_type = "password"
    end

     def to_hash
      instance_variables.inject({}) do |hash,var| 
        hash[var[1..-1].to_sym] = instance_variable_get(var) 
        hash 
      end
    end
  end
end