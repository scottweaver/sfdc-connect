module SfdcConnect 
  require "sfdc-connect"  

 # Provides basic query and object access support.
  class SfdcRESTQuery    
    extend ResponseValidator
    extend QuerySupport
    include HTTParty

    @crm_type
    @query_fields

    # Use this to the set the SFDC type name (used in object requests)
    # if your class' name does not match.  This is helpful for custom
    # objects which always end in '__c' which would force you to have
    # fairly ugly class names.
    def self.crm_type(crm_type)
      @crm_type = crm_type
    end

    # Sets an array of field names that will be used in 
    # 'where' and 'find' method calls.  If this is not set
    # the value for the "field_names" method will be used.
    def self.query_fields(*query_fields)
      @query_fields = query_fields
    end

    # Retrieves an object by its id.  Uses the name of the class as the 
    # object name.
    def self.find(id)
      execute_request SfdcConnect.resource_url(id, resource_name)
    end

    # Retrieves ALL the objects of this type. WARNING, this call can take 
    # a large amount of time to complete and can return a huge dataset.  
    # You have been warned.
    # def self.all
      # execute_request query_url("SELECT name from #{resource_name}")
    # end

    # Executes an arbitrary SOQL query.
    def self.search(soql)
      execute_request SfdcConnect.query_url(soql)
    end

    def self.where(where_clause, arguments=[])
      search(<<-SOQL
        Select #{@query_fields.join(", ")} from #{resource_name} where 
         #{interpolate_where_clause(where_clause, arguments)}
      SOQL
      )
    end

    def self.metadata
      @metadata = @metadata || execute_request(SfdcConnect.metadata_url(resource_name))
      @metadata
    end

    def self.field_names
      @field_names = @field_names || metadata["fields"].collect do |obj|
        obj["name"]
      end
      @field_names
    end

    private

    def self.execute_request(url, result=[], raw=false)      
      set_headers            
      response=get(SfdcConnect.sfdc_instance_url+url) 
      validate_response response      
      handle_response response
    end

    def self.handle_response(response, raw=false)
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
end