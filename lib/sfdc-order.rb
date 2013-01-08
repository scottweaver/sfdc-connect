require "httparty"
require "sfdc-object"

module SfdcConnect
  class Order < BaseSfdcObject
    include HTTParty
    extend ResponseValidator    

    crm_type 'SAP_Order__c'
    
    def self.orders_for_account(account_id)
      soql= <<-SOQL
      Select CreatedDate, Company_Name__c, Webkey_Name__c, Company_Name_English__c,
        Pre_Order_Status__c, SAP_Quote_ID__c, Order_Lane__c, Maint_Status__c,
        Release_to_Partner__c, Name, Validity_End_Date__c, 
          (Select Back_Maint_Total__c, Maint_Renewal_Total__c, Maint_Total__c, 
            Proposal_Total__c, Name, Opportunity__c 
           From Opportunity_Proposals__r p)
      From SAP_Order__c
      Where 
        Partner_Account__r.Id ='#{account_id}'
      SOQL
      search(soql)
    end

  end
  
end