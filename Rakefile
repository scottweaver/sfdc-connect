require "bundler/gem_tasks"
require_relative "lib/sfdc-connect"
require_relative "config/sfdc-connect-config.rb"

 class StubQuery < SfdcConnect::SfdcRESTQuery
      crm_type "Account"
 end

desc "Generates Account stub data from SFDC"
task :generate_account_stubs do |t| 
  result = StubQuery.find "001V0000006FAyBIAW"
  File.open(File.dirname(__FILE__) + "/spec/fixtures/001V0000006FAyBIAW.json", "w") do |file|  
    file << result
  end
  
end