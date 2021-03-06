require File.expand_path '../../test_helper', __dir__

# Test class for Delete Virtual Machine Request
class TestDeleteVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_virtual_machine_success
    @promise.stub :value!, true do
      @virtual_machines.stub :delete, @promise do
        assert @service.delete_virtual_machine('fog-test-rg', 'fog-test-server')
      end
    end
  end

  def test_delete_virtual_machine_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_machines.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_virtual_machine('fog-test-rg', 'fog-test-server') }
      end
    end
  end
end
