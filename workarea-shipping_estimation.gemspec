$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'workarea/shipping_estimation/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'workarea-shipping_estimation'
  s.version     = Workarea::ShippingEstimation::VERSION
  s.authors     = ['Matt Duffy']
  s.email       = ['mduffy@workarea.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-shipping-estimation'
  s.summary     = 'Shipping estimation plugin for the Workarea Commerce platform.'
  s.description = 'Shipping estimation plugin for the Workarea Commerce platform.'
  s.files = `git ls-files`.split("\n")
  s.license = 'Business Software License'

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'workarea', '~> 3.x'
end
