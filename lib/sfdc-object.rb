module SfdcConnect
 class BaseSfdcObject < SfdcRESTQuery
    
    include DateAssistant

    def initialize(sobject={})   
      if (sobject.is_a? Array)     
        sobject = sobject[0]      
      end
      
      @store = sobject.inject({}) do|h, so|            
        if so[0]             
          new_key = so[0].downcase.partition('__c')[0]
          h[new_key] = so[1]
          h
        end
      end || {}
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
end