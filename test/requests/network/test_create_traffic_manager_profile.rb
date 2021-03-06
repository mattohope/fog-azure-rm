require File.expand_path '../../test_helper', __dir__

# Test class for Create Traffic Manager Profile
class TestCreateTrafficManagerProfile < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_create_traffic_manager_profile_success
    response = ApiStub::Requests::Network::TrafficManagerProfile.create_traffic_manager_profile_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, response do
        assert_equal @service.create_traffic_manager_profile('fog-test-rg', 'fog-test-profile', 'Performance',
                                                             'fog-test-app', 30, 'http', 80, '/monitorpage.aspx'),
                     JSON.parse(response)
      end
    end
  end

  def test_create_traffic_manager_profile_failure
    exception = RestClient::Exception.new
    exception.instance_variable_set(:@response, '{"code": "ResourceNotFound", "message": "mocked exception message"}')
    response = -> { fail exception }
    @token_provider.stub :get_authentication_header, response do
      assert_raises RuntimeError do
        @service.create_traffic_manager_profile('fog-test-rg', 'fog-test-profile', 'Performance', 'fog-test-app', 30,
                                                'http', 80, '/monitorpage.aspx')
      end
    end
  end
end
