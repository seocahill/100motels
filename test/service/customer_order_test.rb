require 'test_helper'

class CustomerOrderTest < ActiveSupport::TestCase

  def setup
    order = FactoryGirl.create(:order)
    token = {
      id: "tok_2vGX2kh9bIEJlA",
      livemode: false,
      created: 1384196760,
      used: false,
      object: "token",
      type: "card",
      card: {
        id: "card_2vGXe6nNXnln8p",
        object: "card",
        last4: "4242",
        type: "Visa",
        exp_month: 12,
        exp_year: 2014,
        fingerprint: "RB85KOQliRhIugae",
        customer: null,
        country: "US",
        name: "John Smith"
      }
    }
    customer = {
      object: "customer",
      created: 1384196762,
      id: "cus_2vGXmABiU6nUvB",
      livemode: false,
      description: null,
      email: "john@smith.com",
      delinquent: false,
      metadata: {},
      subscription: null,
      discount: null,
      account_balance: 0,
      cards: {
        object: "list",
        count: 1,
        url: "/v1/customers/cus_2vGXmABiU6nUvB/cards",
        data:
        [
          {
            id: "card_2vGXe6nNXnln8p",
            object: "card",
            last4: "4242",
            type: "Visa",
            exp_month: 12,
            exp_year: 2014,
            fingerprint: "RB85KOQliRhIugae",
            customer: "cus_2vGXmABiU6nUvB",
            country: "US",
            name: "John Smith",
            address_line1: null,
            address_line2: null,
            address_city: null,
            address_state: null,
            address_zip: null,
            address_country: null,
            cvc_check: "pass",
            address_line1_check: null,
            address_zip_check: null
          }
        ]
      },
      default_card: "card_2vGXe6nNXnln8p"
    }
    customer_order = CustomerOrder.new(order, token)
  end






end