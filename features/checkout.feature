Feature: Checkout

  Scenario: Cart is empty

    An order must contain at least one item

    Given my cart is empty
    Then I should not be able to check out

  Scenario: Successful checkout

    Given my cart contains events
    When I check out with valid details
    Then the order should be placed
    And the customers details should be captured

  Scenario Outline: Attempt to complete checkout without completing mandatory fields

    The name and email fields are mandatory

    Given I am checking out with valid details
    But I leave the <field> blank
    When I attempt to place the order
    Then the order should not be placed
    And the error message should be "<message>"

    Examples:
      | field    | message                              |
      | name     | Name can't be blank                  |
      | email    | Email can't be blank                 |
    