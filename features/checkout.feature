Feature: Checkout

  Scenario: Cart is empty

    An order must contain at least one item

    When I visit the homepage
    Given my cart is empty
    And I attempt to place an order
    Then I should see "Add something to your cart first"

  Scenario: Successful checkout

    Given my cart contains events
    When I check out with valid details
    Then the order should be placed
    And the customers details should be captured

  