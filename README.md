Workarea Shipping Estimation
================================================================================

A Workarea Commerce plugin that adds shipping estimation functionality to the storefront cart page.

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-shipping_estimation'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

Configuration
--------------------------------------------------------------------------------

This plugin utilizes the [Geocoder gem](https://github.com/alexreisner/geocoder) for gathering address information required to estimate shipping from a postal code. Depending on the services you decide to use, it may require [configuring Geocoder](https://github.com/alexreisner/geocoder#geocoding-service-lookup-configuration).

Workarea recommends using Google for geolocation services. However, Google is not free and requires the use of an [API key](https://developers.google.com/maps/documentation/geocoding/get-api-key).

To configure a pay-as-you-go Google API key with Geocoder:

```ruby
Geocoder.configure(
  lookup: :google,
  api_key: Rails.application.secrets.google_maps_api_key
)
```

Testing
--------------------------------------------------------------------------------

When writing tests for/around this gem, make sure to wrap your submissions of the shipping estimate with VCR:

```ruby
VCR.use_cassette(:geocoding) do
  within '#estimate_shipping_form' do
    select 'Ground - $7.00', from: 'shipping_service'
    click_button 'estimate_shipping'
  end
end
```

Workarea Commerce Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Shipping Estimation is released under the [Business Software License](LICENSE)
