module ApiStub
  module Models
    module Network
      # Mock class for Traffic Manager End Point Model
      class TrafficManagerEndPoint
        def self.create_traffic_manager_end_point_response
          endpoint = '{
            "id": "/subscriptions/######/resourceGroups/fog-test-rg/providers/Microsoft.Network/trafficManagerProfiles/fog-test-profile/azureEndpoints/fog-test-end-point?api-version=2015-11-01",
            "name": "fog-test-end-point",
            "type": "Microsoft.Network/trafficManagerProfiles/azureEndpoints",
            "properties": {
              "endpointStatus": "Enabled",
              "endpointMonitorStatus": "Online",
              "targetResourceId": "/subscriptions/######/resourceGroups/fog-test-rg/providers/Microsoft.Network/",
              "target": "myapp.azurewebsites.net",
              "weight": 10,
              "priority": 3,
              "endpointLocation": "centralus"
            }
          }'
          JSON.parse(endpoint)
        end
      end
    end
  end
end
