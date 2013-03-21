require "httparty"
require "sfdc-object"

module SfdcConnect
  class Account < BaseSfdcObject
    include HTTParty
    extend ResponseValidator

    def self.account_by_payer_id(payer_id, fields=[ "a.Id", "a.Name", "a.SAP_Payer_Id__c"])
      result = search(%Q[Select #{fields.join(", ")} 
              from Account a where a.SAP_Payer_Id__c = '#{payer_id}'
              and a.Partner_Account_Status__c='Active'
    ])
      puts result.inspect
      Account.new(result)
    end
  end
end
