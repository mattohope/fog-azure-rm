module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def check_storage_account_name_availability(params)
          Fog::Logger.debug "Checking Name availability: #{params.name}."
          begin
            promise = @storage_mgmt_client.storage_accounts.check_name_availability(params)
            result = promise.value!
            name_available_obj = Azure::ARM::Storage::Models::CheckNameAvailabilityResult.serialize_object(result.body)
            if name_available_obj['nameAvailable'] == true
              Fog::Logger.debug "Name: #{params.name} is available."
              true
            else
              Fog::Logger.debug "Name: #{params.name} is not available."
              Fog::Logger.debug "Reason: #{name_available_obj['reason']}."
              false
            end
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception checking name availability: #{e.body['error']['message']}"
            raise msg if e.body['error']['code'] == 'ResourceGroupNotFound'
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_storage_account_name_availability(params)
          Fog::Logger.debug "Name: #{params.name} is available."
          true
        end
      end
    end
  end
end
