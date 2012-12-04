require "sfdc-connect/version"
require 'httparty'

module SfdcConnect

  def self.sfdc_url
    @@sfdc_url
  end

  def self.sfdc_url=(url)
    @@sfdc_url=url
  end

  def self.default_credentials
    @@default_credentials
  end

  def self.default_credentials=(credentials)
    @@default_credentials=credentials
  end

  class Authenticator
    include HTTParty
    
    def authenticate(credentials=SfdcConnect.default_credentials)
       response = self.class.post(SfdcConnect.sfdc_url,
        query: credentials.to_hash)        
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
