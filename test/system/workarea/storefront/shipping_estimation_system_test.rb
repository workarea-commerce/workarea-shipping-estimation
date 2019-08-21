require 'test_helper'

module Workarea
  module Storefront
    class ShippingEstimationSystemTest < Workarea::SystemTest
      setup :product, :tax_category, :shipping_service

      def product
        @product = create_product(
          name: 'Integration Product',
          variants: [
            { name: 'SKU1', sku: 'SKU1', regular: 5.to_m },
            { name: 'SKU2', sku: 'SKU2', regular: 6.to_m }
          ]
        )
        create_inventory(id: 'SKU1', policy: 'standard', available: 2)
      end

      def tax_category
        create_tax_category(
          name: 'Sales Tax',
          code: '001',
          rates: [{ percentage: 0.07, country: 'US', region: 'PA' }]
        )
      end

      def shipping_service
        create_shipping_service(
          name: 'Ground',
          tax_code: '001',
          rates: [{ price: 7.to_m }]
        )
      end

      def set_and_login_user
        user = create_user(email: 'bcrouse@workarea.com', password: 'w3bl1nc')
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

        visit storefront.login_path
        within '#login_form' do
          fill_in 'email', with: 'bcrouse@workarea.com'
          fill_in 'password', with: 'w3bl1nc'
          click_button t('workarea.storefront.users.login')
        end
      end

      def test_estimating_shipping
        visit storefront.product_path(@product)
        select @product.skus.first, from: 'sku'
        click_button t('workarea.storefront.products.add_to_cart')
        click_link t('workarea.storefront.carts.view_cart')

        VCR.use_cassette('geolocation') do
          within '#estimate_shipping_form' do
            fill_in 'postal_code', with: '19143'
            click_button 'estimate_shipping'
          end

          within '#estimate_shipping_form' do
            select 'Ground - $7.00', from: 'shipping_service'
            click_button 'estimate_shipping'
          end

          assert(page.has_content?('0.49'))
          assert(page.has_content?('12.49'))
        end
      end

      def test_estimating_shipping_automatically_for_logged_in_user
        set_and_login_user

        visit storefront.product_path(@product)
        select @product.skus.first, from: 'sku'
        click_button t('workarea.storefront.products.add_to_cart')

        VCR.use_cassette('geolocation_19106') do
          click_link t('workarea.storefront.carts.view_cart')

          within '#estimate_shipping_form' do
            assert_equal('19106', find_field('postal_code').value)
            select 'Ground - $7.00', from: 'shipping_service'
            click_button 'estimate_shipping'
          end
        end

        assert(page.has_content?('0.49'))
        assert(page.has_content?('12.49'))
      end
    end
  end
end
