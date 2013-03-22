require "httparty"
require "sfdc-object"

module SfdcConnect
  class Account < BaseSfdcObject

     query_fields "Id", "Name", "SAP_Payer_Id__c"
     crm_type :Account

    def self.account_by_payer_id(payer_id)
      result = where("SAP_Payer_Id__c = '?' and Partner_Account_Status__c='Active'", [payer_id])
      p result.inspect
      new(result[0])
    end
  end
end
