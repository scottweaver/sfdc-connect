module SfdcConnect

  # Utility for validating reponses from SFDC REST calls
  module ResponseValidator    
    def validate_response(response)
      raise "HTTP Error #{response.code}: #{response.parsed_response}" if response.code >= 400
      raise "SFDC Error: #{response['error']} - #{response['error_description']}" if response["error"]
    end
  end

  module DateAssistant

    VALID_FORMATS = {
      sfdc_iso8601: /\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])T([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])(?:.\d{3})?[+|-](0[0-9]|1[0-2])(00|15|30|45)/,
      myd1: /(0[1-9]|1[1-2])\/([0-2][0-9]|3[0-1])\/(\d{4})/,
      ymd1: /(\d{4})-(0[1-9]|1[1-2])-([0-2][0-9]|3[0-1])/
    }

    # Checks whether the string is a valid date format (found in SFDC)
    def date?(date_as_string)  
      !date_format(date_as_string).nil?
    end

    def date_format(date_as_string)
      VALID_FORMATS.values.select do |regex|
        regex === date_as_string
      end[0]   
      
    end
  end
end