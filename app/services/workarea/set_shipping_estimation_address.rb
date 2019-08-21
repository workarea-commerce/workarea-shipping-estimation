module Workarea
  class SetShippingEstimationAddress
    delegate :shipping, :shippings, :order, to: :@checkout

    def initialize(checkout, location, user = nil)
      @checkout = checkout
      @location = location
      @user = user
    end

    def perform
      return if shipping.nil?
      set_address unless shipping.address.present?
      recalculate_price
    end

    private

    def set_address
      if @user.present? && @user.default_shipping_address.present?
        shipping.set_address(
          @user.default_shipping_address
              .attributes
              .except(*excluded_saved_adddress_fields)
              .merge(used_for_shipping_estimation: true)
        )
      elsif @location.postal_code.present?
        shipping.set_address(
          postal_code: @location.postal_code,
          region: @location.region,
          country: @location.country,
          used_for_shipping_estimation: true
        )
      end
    end

    def recalculate_price
      Pricing.perform(order, shippings)
      Workarea::Checkout::Steps::Shipping.new(@checkout).update(
        shipping_service: shipping.shipping_service&.name
      )
    end

    def excluded_saved_adddress_fields
      %w(_id _type created_at updated_at last_shipped_at last_billed_at)
    end
  end
end
