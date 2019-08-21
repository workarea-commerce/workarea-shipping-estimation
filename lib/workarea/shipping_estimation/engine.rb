module Workarea
  module ShippingEstimation
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::ShippingEstimation
    end
  end
end
