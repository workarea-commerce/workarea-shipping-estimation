require 'test_helper'

module Workarea
  class Shipping
    class AddressEstimationValidationTest < TestCase
      def test_validation
        address = Shipping::Address.new(
          region: 'PA',
          country: 'US',
          postal_code: '19106'
        )

        refute(address.valid?)

        address.used_for_shipping_estimation = true
        assert(address.valid?)
        assert(address.first_name.nil?)
        assert(address.last_name.nil?)
        assert(address.street.nil?)
        assert(address.city.nil?)

        address.used_for_shipping_estimation = false
        refute(address.valid?)

        address.assign_attributes(
          first_name: 'Test',
          last_name: 'User',
          street: '12 N. 3rd St.',
          city: 'Philadelphia'
        )
        assert(address.valid?)

        address.used_for_shipping_estimation = true
        assert(address.valid?)
        assert_equal('Test', address.first_name)
        assert_equal('User', address.last_name)
        assert_equal('12 N. 3rd St.', address.street)
        assert_equal('Philadelphia', address.city)
      end
    end
  end
end
