require 'test_helper'

module Workarea
  class SetShippingEstimationAddressTest < TestCase
    setup :set_shipping_service

    def set_shipping_service
      create_shipping_service(
        name: 'Ground',
        tax_code: '001',
        rates: [{ price: 7.to_m }]
      )
    end

    def user
      @user ||= create_user.tap do |user|
        user.auto_save_shipping_address(
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '22 S. 3rd St.',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US',
          phone_number: '2159251800'
        )
      end
    end

    def location
      @location ||= Geolocation.new(
        'HTTP_GEOIP_CITY_COUNTRY_CODE' => 'US',
        'HTTP_GEOIP_REGION' => 'PA',
        'HTTP_GEOIP_POSTAL_CODE' => '19106'
      )
    end

    def order
      @order ||= create_order(items: [{ product_id: '1234', sku: 'SKU' }])
    end

    def test_setting_address_from_user_saved_addresses
      checkout = Checkout.new(order, user)

      SetShippingEstimationAddress.new(
        checkout,
        Geolocation.new({}),
        user
      ).perform

      assert(checkout.shipping.reload.address.present?)

      address = checkout.shipping.address
      assert_equal('22 S. 3rd St.', address.street)
      assert_equal('Philadelphia', address.city)
      assert_equal('19106', address.postal_code)
      assert_equal('PA', address.region)
      assert_equal('US', address.country.alpha2)
    end

    def test_setting_address_from_gelocation_data
      checkout = Checkout.new(order)

      SetShippingEstimationAddress.new(checkout, location).perform

      assert(checkout.shipping.reload.address.present?)

      address = checkout.shipping.address
      assert_equal('19106', address.postal_code)
      assert_equal('PA', address.region)
      assert_equal('US', address.country.alpha2)
    end

    def test_recalculate_shipping_price_when_quantity_changes
      item = order.items.first
      pricing = create_pricing_sku(id: item.sku)
      pricing.prices.create!(regular: 10.to_m)
      checkout = Checkout.new(order)
      service = create_shipping_service(
        rates: [
          { price: 1.to_m, tier_max: 19.to_m },
          { price: 2.to_m, tier_min: 20.to_m }
        ]
      )
      address_params = {
        first_name: 'Bob',
        last_name: 'Clams',
        street: '123 Fake Street',
        city: 'Philadelphia',
        region: 'PA',
        country: 'US',
        postal_code: '19145'
      }

      checkout.shipping.set_shipping_service(service.attributes)
      checkout.shipping.set_address(address_params)
      SetShippingEstimationAddress.new(checkout, location).perform
      Pricing.perform(order, checkout.shippings)

      assert_equal(10.to_m, order.subtotal_price)
      assert_equal(1.to_m, checkout.shipping.shipping_total)

      item.update!(quantity: 2)
      order.reload
      checkout.shipping.set_shipping_service(service.attributes)
      checkout.shipping.set_address(address_params)
      SetShippingEstimationAddress.new(checkout, location).perform
      Pricing.perform(order, checkout.shippings)

      assert_equal(20.to_m, order.subtotal_price)
      assert_equal(2.to_m, checkout.shipping.shipping_total)
    end
  end
end
