module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def get_records_from_record_set(resource_group, name, zone_name, record_type)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{name}?api-version=2015-05-04-preview"
          Fog::Logger.debug "Getting all records from RecordSet #{name} of type '#{record_type}' in zone #{zone_name}"

          existing_records = []
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            dns_response = RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue Exception => e
            Fog::Logger.warning "Exception trying to get existing #{record_type} records for the record set: #{name}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end

          begin
            dns_hash = JSON.parse(dns_response)
            case record_type
            when 'A'
              dns_hash['properties']['ARecords'].each do |record|
                Fog::Logger.debug "AzureDns:RecordSet - A record is: #{record}"
                existing_records.push(record['ipv4Address'])
              end
            when 'CNAME'
              Fog::Logger.debug "AzureDns:RecordSet - CNAME record is: #{dns_hash['properties']['CNAMERecord']['cname']}"
              existing_records.push(dns_hash['properties']['CNAMERecord']['cname'])
            end
            existing_records
          rescue Exception => e
            Fog::Logger.warning "Exception trying to parse response: #{dns_response}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def get_records_from_record_set(_resource_group, _name, _zone_name, _record_type)
          [
            '1.2.3.4',
            '1.2.3.5',
            '1.2.3.6'
          ]
        end
      end
    end
  end
end
