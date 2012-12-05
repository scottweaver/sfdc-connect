require "sfdc-connect/version"
require 'httparty'

module SfdcConnect

  class << self
    attr_accessor :sfdc_login_url, :default_credentials, :sfdc_instance_url
  end

  class Authenticator
    include HTTParty

    def authenticate(credentials=SfdcConnect.default_credentials)
      response = self.class.post(SfdcConnect.sfdc_login_url,
        query: credentials.to_hash)   
      raise "SFDC Error: #{response['error']} - #{response['error_description']}" if response["error"]
      response["access_token"]
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
