require 'fog/azurerm/core'

module Fog
  module Network
    # Fog Service Class for AzureRM
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/network'
      request :create_virtual_network
      request :delete_virtual_network
      request :list_virtual_networks
      request :check_for_virtual_network

      model_path 'fog/azurerm/models/network'
      model :virtual_network
      collection :virtual_networks

      request_path 'fog/azurerm/requests/network'
      request :create_public_ip
      request :delete_public_ip
      request :list_public_ips
      request :check_for_public_ip

      model_path 'fog/azurerm/models/network'
      model :public_ip
      collection :public_ips

      # Mock class for Network Service
      class Mock
        def initialize(_options = {})
        end
      end

      # Real class for Network Service
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_network'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret])
          @network_client = ::Azure::ARM::Network::NetworkManagementClient.new(credentials)
          @network_client.subscription_id = options[:subscription_id]
        end
      end
    end
  end
end