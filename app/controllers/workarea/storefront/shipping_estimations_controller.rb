module Workarea
  class Storefront::ShippingEstimationsController < Storefront::ApplicationController
    def create
      address = Geocoder.search(params[:postal_code]).first

      current_shipping.set_address(
        postal_code: address.postal_code,
        region: address.state_code,
        country: address.country_code,
        used_for_shipping_estimation: true
      )

      Workarea::Checkout::Steps::Shipping.new(current_checkout).update(params)
      redirect_to cart_path
    end
  end
end
