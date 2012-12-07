require "sfdc-connect/version"
require 'httparty'
require "cgi"
require "sfdc-support"

module SfdcConnect

  class << self
    attr_accessor :sfdc_login_url, :default_credentials, :sfdc_instance_url, :access_token
  end

  # Provides basic query and object access support.
  class SfdcRESTQuery
    extend ResponseValidator
    include HTTParty

    @crm_type

    # Use this to the set the SFDC type name (used in object requests)
    # if your class' name does not match.  This is helpful for custom
    # objects which always end in '__c' which would force you to have
    # fairly ugly class names.
    def self.crm_type(crm_type)
      @crm_type = crm_type
    end

    # Retrieves an object by its id.  Uses the name of the class as the 
    # object name.
    def self.find(id)
      execute_request resource_url(id)
    end

    # Retrieves ALL the objects of this type. WARNING, this call can take 
    # a large amount of time to complete and can return a huge dataset.  
    # You have been warned.
    # def self.all
      # execute_request query_url("SELECT name from #{resource_name}")
    # end

    # Executes an arbitrary SOQL query.
    def self.search(soql)
      execute_request query_url(soql)
    end

    def self.metadata
      execute_request metadata_url
    end

    def self.field_names
      @field_names = @field_names || metadata["fields"].collect do |obj|
        obj["name"]
      end
      @field_names
    end

    private

    def self.query_url(soql)
      "/services/data/v26.0/query/?q=#{CGI::escape(soql)}"                
    end

    def self.resource_url(id)
      url="/services/data/v26.0/sobjects/#{resource_name}/#{id}"
    end

    def self.metadata_url
      url="/services/data/v26.0/sobjects/#{resource_name}/describe"
    end

    def self.execute_request(url, result=[])      
      set_headers            
      response=get(SfdcConnect.sfdc_instance_url+url) 
      validate_response(response)      
      if response['records']
        continue_request(response)
      elsif response["fields"]
        response
      else
        new_sfdc_object_instance(response.parsed_response)
      end
    end

    # Called when SFDC indicates that there are more results in the
    # query response than can be returned in one REST request.
    def self.continue_request(response, result=[])
      result.concat(response['records'])
      execute_request(response['nextRecordsUrl'], result) unless response["done"]
      result
    end

    def self.set_headers
      headers 'Authorization' => "Bearer #{SfdcConnect.access_token}"
    end

    def self.resource_name
      @crm_type || self.name.split('::')[-1]
    end

    def self.new_sfdc_object_instance(sobject)
      if(ancestors.include? SfdcConnect::BaseSfdcObject)
        new(sobject)
      else
        BaseSfdcObject.new(sobject)
      end
    end
  end
  
  class BaseSfdcObject < SfdcRESTQuery
    include DateAssistant

    def initialize(sobject={})               
      @store = sobject.inject({}) do|h, so|                    
        new_key = so[0].downcase.partition('__c')[0]
        h[new_key] = so[1]
        h
      end
    end

    def respond_to?(method_id)
      if(!super)
        @store.include?(method_id.to_s) || @store.include?(method_id.to_s.delete("_"))
      else
        super
      end
    end

    def method_missing(method_id, *arguments, &block)
      if(@store.include? method_id.to_s)
        coherce_value(method_id.to_s, @store[method_id.to_s])
      elsif(@store.include? method_id.to_s.delete("_"))
        coherce_value(method_id.to_s.delete("_"), @store[method_id.to_s.delete("_")])
      else
        super
      end
    end

    private

    # Coherce certain string value into a more appropriate complex type if 
    # appropriate
    def coherce_value(name, value)
      
      if(date? value)          
        DateTime.parse(value)
      else
        value
      end        
    end
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