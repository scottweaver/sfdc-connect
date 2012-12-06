require "sfdc-connect/version"
require 'httparty'
require "cgi"

module SfdcConnect

  class << self
    attr_accessor :sfdc_login_url, :default_credentials, :sfdc_instance_url, :access_token
  end

  # Utility for validating reponses from SFDC REST calls
  module ResponseValidator    
    def validate_response(response)
      raise "HTTP Error #{response.code}: #{response.parsed_response}" if response.code >= 400
      raise "SFDC Error: #{response['error']} - #{response['error_description']}" if response["error"]
    end
  end

  # Provides basic query and object access support.
  class SfdcRESTQuery
    include ResponseValidator
    include HTTParty

    # Retrieves an object by its id.  Uses the name of the class as the 
    # object name.
    def self.retrieve(id)
      do_get resource_url(id)
    end

    # Retrieves ALL the objects of this type. WARNING, this call can take 
    # a large amount of time to complete and can return a huge dataset.  
    # You have been warned.
    def self.all
      do_get query_url("SELECT name from #{resource_name}")
    end

    # Executes an arbitrary SOQL query.
    def self.search(soql)
      do_get query_url(soql)
    end

    private

    def self.query_url(soql)
      "/services/data/v26.0/query/?q=#{CGI::escape(soql)}"                
    end

    def self.resource_url(id)
      "/services/data/v26.0/sobjects/#{resource_name}/#{id}?fields=Id,name"
    end

    def self.do_get(url, result=[])
      set_headers            
      response=get(SfdcConnect.sfdc_instance_url+url) 
      validate_response(response)
      result.concat(response['records'])
      do_get(response['nextRecordsUrl'], result) unless response["done"]
      result
    end

    def self.set_headers
      headers 'Authorization' => "Bearer #{SfdcConnect.access_token}"
    end

    def self.resource_name
      self.name.split('::')[-1]
    end
    
  end

  
  class BaseSfdcObject < SfdcRESTQuery
      

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