Workarea Shipping Estimation 1.1.1 (2018-10-30)
--------------------------------------------------------------------------------

*   Recalculate Shipping when Cart is Updated

    Estimating shipping charges in the cart did not previously update when
    the subtotal changed, and causes UX issues because the shipping total in
    the cart's summary could be different from the estimated shipping cost
    given in the dropdown. Workarea Shipping Estimation now calculates the
    shipping total when rendering the cart in order to show the most
    up-to-date shipping cost at all times.

    SHIPEST-10
    Tom Scott

*   Leverage Workarea Changelog task

    ECOMMERCE-5355
    Curt Howard



Workarea Shipping Estimation 1.1.0 (2018-02-06)
--------------------------------------------------------------------------------

*   Remove geocoder dependency from gemspec

    Workarea already defines a dependency on geocoder. There is no need
    to manage it for this plugin as well.

    SHIPEST-9
    Matt Duffy


Workarea Shipping Estimation 1.0.0 (2017-10-17)
--------------------------------------------------------------------------------

*   Autofill shipping estimation form based on user address or geolocation info

    SHIPEST-6, SHIPEST-8
    Matt Duffy

*   Fix mention of weblinc, locale file, add css margin under estimator, loosen postal code field for Canada

    SHIPEST-5
    Dave Barnow

*   Update for compatibility with workarea v3

    SHIPEST-3
    Matt Duffy
